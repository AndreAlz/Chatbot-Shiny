library(shiny)
library(caret)
library(DBI)
library(RMySQL)
library(xlsx)
source("crcoan.R")
shinyServer(function(input, output, session) {
  mknn=creaModelknn()
  mensaje=eventReactive(input$enviar,input$texto)
  pre=reactiveVal(0)
  interact=0
  observeEvent(input$enviar,{
    if (interact==0) {
      data=partirmensaje(mensaje())
      newvalue=predict(mknn,data[,2:5])
      pre(newvalue)
      updateTextInput(session,inputId = "texto", value = "")
    }
  })
  observeEvent(pre(),{
    valo=as.numeric(pre())
    if(valo==1){
      output$resp=renderText("ok pero necesito tu numero de ticket")
      interact<<-1
    }
    if(valo==2){
      output$resp=renderText("desde que fecha")
      interact<<-1
    }
  })
  observeEvent(input$enviar,{
    conn = connectMySQL()
    updateTextInput(session,inputId = "texto", value = "")
    if(interact==1){
      valo=as.numeric(pre())
      if(valo==1){
        consulta="select wo.WORKORDERID AS 'TICKET ID',
                           wo.TITLE AS 'ASUNTO',
                           aau.FIRST_NAME AS 'USUARIO',
                           ti.FIRST_NAME AS 'TECNICO',
                           rrs.RESOLUTION AS 'COMENTARIOS',
                           std.STATUSNAME AS 'ESTADO',
                           DATE_FORMAT(TIMESTAMPADD(Second,TIMESTAMPDIFF(SECOND,UTC_TIMESTAMP(),now())+(wo.CREATEDTIME/1000),'1970-01-01 00:00:00'),'%Y-%m-%d %h:%i:%s')AS 'FECHACREA',
                           DATE_FORMAT(TIMESTAMPADD(Second,TIMESTAMPDIFF(SECOND,UTC_TIMESTAMP(),now())+(wo.COMPLETEDTIME/1000),'1970-01-01 00:00:00'),'%Y-%m-%d %h:%i:%s')AS 'FECHACIERRE'
                           from WorkOrder  wo
                           LEFT JOIN RequestResolver rrr ON wo.WORKORDERID=rrr.REQUESTID
                           LEFT JOIN RequestResolution rrs ON rrr.REQUESTID=rrs.REQUESTID
                           LEFT JOIN WorkOrderStates wos ON wo.WORKORDERID=wos.WORKORDERID
                           LEFT JOIN SDUser sdu ON wo.REQUESTERID=sdu.USERID
                           LEFT JOIN AaaUser aau ON sdu.USERID=aau.USER_ID
                           LEFT JOIN SDUser td ON wos.OWNERID=td.USERID
                           LEFT JOIN AaaUser ti ON td.USERID=ti.USER_ID
                           LEFT JOIN StatusDefinition std ON wos.STATUSID=std.STATUSID
                           WHERE wo.WORKORDERID="
        sqlquery=paste(consulta,toString(input$texto),sep = " ")
        conn = connectMySQL()
        res = dbSendQuery(conn, sqlquery)
        result = dbFetch(res, 1)
        dbDisconnect(conn = conn)
        dbClearResult(res)
        output$resp2=renderDataTable({
          result
        })
      }
      if(valo==2){
        consulta="select wo.WORKORDERID AS 'TICKET ID',
                   wo.TITLE AS 'ASUNTO',
                   aau.FIRST_NAME AS 'USUARIO',
                   ti.FIRST_NAME AS 'TECNICO',
                   std.STATUSNAME AS 'ESTADO',
                   DATE_FORMAT(TIMESTAMPADD(Second,TIMESTAMPDIFF(SECOND,UTC_TIMESTAMP(),now())+(wo.CREATEDTIME/1000),'1970-01-01 00:00:00'),'%Y-%m-%d %h:%i:%s')AS 'FECHACREA',
                   DATE_FORMAT(TIMESTAMPADD(Second,TIMESTAMPDIFF(SECOND,UTC_TIMESTAMP(),now())+(wo.COMPLETEDTIME/1000),'1970-01-01 00:00:00'),'%Y-%m-%d %h:%i:%s')AS 'FECHACIERRE'
                   from WorkOrder  wo
                   LEFT JOIN RequestResolver rrr ON wo.WORKORDERID=rrr.REQUESTID
                   LEFT JOIN RequestResolution rrs ON rrr.REQUESTID=rrs.REQUESTID
                   LEFT JOIN WorkOrderStates wos ON wo.WORKORDERID=wos.WORKORDERID
                   LEFT JOIN SDUser sdu ON wo.REQUESTERID=sdu.USERID
                   LEFT JOIN AaaUser aau ON sdu.USERID=aau.USER_ID
                   LEFT JOIN SDUser td ON wos.OWNERID=td.USERID
                   LEFT JOIN AaaUser ti ON td.USERID=ti.USER_ID
                   LEFT JOIN StatusDefinition std ON wos.STATUSID=std.STATUSID
                   WHERE FROM_UNIXTIME(wo.CREATEDTIME/1000) BETWEEN ' "
        consultap2="00:00:00'  AND NOW() "
        sqlquery=paste(consulta,toString(input$texto),consultap2,sep = " ")
        conn=connectMySQL()
        res = dbSendQuery(conn, sqlquery)
        result = dbFetch(res, n = -1)
        dbDisconnect(conn = conn)
        dbClearResult(res)
        output$resp2=renderDataTable({
          result
        })
      }
      interact<<-0
      pre(0)
    }
  })
})
