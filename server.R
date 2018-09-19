library(shiny)
library(caret)
library(DBI)
library(RMySQL)
library(xlsx)
library(lubridate)
source("crcoan.R")
shinyServer(function(input, output, session) {
  model_knn1=creaModelknn(1)
  model_knn2=creaModelknn(2)
  data=0
  observeEvent(input$enviar,{
    eval=partirmensaje(tolower(toString(input$texto)))
    resultado=predict(model_knn1, eval[,6:7])
    if(resultado==1){
      resul=predict(model_knn2, eval[,2:5])
      if(resul==1){
        output$respuesta=renderText("Prodias indicarme el numero de ticket ?")
      }else{
        output$respuesta=renderText("Prodias indicarme la fecha ?")
      }
    }
    if (resultado==2) {

      if(!is.na(as.numeric(input$texto))==TRUE){
        output$respuesta=renderText("Encontre esta informacion de tu ticket.")
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
        sqlquery=paste(consulta,input$texto,sep = " ")
        conn=connectMySQL()
        res = dbSendQuery(conn, sqlquery)
        result = dbFetch(res, 10)
        data<<-result
        dbClearResult(res)
        output$data=renderDataTable(data)
      } else if(isDate(input$texto)==TRUE){
        output$respuesta=renderText("Encontre esta informacion desde su fecha.")
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
        conn=connectMySQL()
        sqlquery=paste(consulta,input$texto,consultap2,sep = " ")
        res = dbSendQuery(conn, sqlquery)
        result = dbFetch(res, 10)
        data<<-result
        dbClearResult(res)
        output$data=renderDataTable(data)
      } else{
        output$respuesta=renderText('Hola soy "Shiny bot", yo te voy a ayudar con muchas cosas :V')
      }
    }
  })
})
