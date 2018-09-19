processingData2 <- function(){
  batch1=read.xlsx('~/shinybot/batch.xlsx' , sheetIndex =2)
  batch2=read.xlsx('~/shinybot/batch.xlsx' , sheetIndex =3)
  trend1=trend2=GE=GC=matrix(NA,nrow = nrow(batch1),ncol = 1)
  for (i in 1:nrow(batch1)) {
    data =data.frame(Word=character(), stringsAsFactors = FALSE)
    temp=strsplit(toString(batch1[i,1]),split = " ")
    ntemp=unlist(temp)
    for (j in 1:length(ntemp)) {
      data[j,1]=ntemp[j]
    }
    t1=1
    t2=1
    for (k in 1:nrow(batch2)) {
      for (l in 1:nrow(data)) {
        if (identical(data[l,1],toString(batch2[k,1]))==TRUE) {
          t1=t1*batch2[k,2]
          t2=t2*batch2[k,3]
        }
      }
    }
    trend1[i,1]=t1
    trend2[i,1]=t2
    if (t1>t2) {
      GE[i,1]=(t1-t2)/(t1+t2)
    }
    if (t1<t2) {
      GE[i,1]=(t2-t1)/(t1+t2)
    }
    if (t1==t2){
      GE[i,1]=0
    }
    GC[i,1]=1-GE[i,1]
    t1=1
    t2=1
  }
  finalbatch=cbind(batch1,trend1,trend2,GE,GC)
  return(finalbatch)
}

processingData1 <- function(){
  batch1=read.xlsx('~/shinybot/batch.xlsx' , sheetIndex =1)
  batch2=read.xlsx('~/shinybot/batch.xlsx' , sheetIndex =3)
  W1=W2=matrix(NA,nrow = nrow(batch1),ncol = 1)
  for (i in 1:nrow(batch1)) {
    data =data.frame(Word=character(), stringsAsFactors = FALSE)
    temp=strsplit(toString(batch1[i,1]),split = " ")
    ntemp=unlist(temp)
    for (j in 1:length(ntemp)) {
      data[j,1]=ntemp[j]
    }
    w1=1
    w2=1
    for (k in 1:nrow(batch2)) {
      for (l in 1:nrow(data)) {
        if (identical(data[l,1],toString(batch2[k,1]))==TRUE) {
          w1=w1*batch2[k,4]
          w2=w2*batch2[k,5]
        }
      }
    }
    W1[i,1]=w1
    W2[i,1]=w2
    w1=1
    w2=1
  }
  finalbatch=cbind(batch1,W1,W2)
  return(finalbatch)
}

creaModelknn <- function(type){
  if(type==1){
    data=readRDS(file = "tranning_data_1.RDS")
    data$Resultado=as.factor(data$Resultado)
    set.seed(6666)
    modelo_knn = train(data[,3:4],data[,2], method = 'knn')
    return(modelo_knn)
  }
  if(type==2){
    data=readRDS(file = "tranning_data_2.RDS")
    data$Resultado=as.factor(data$Resultado)
    set.seed(6666)
    modelo_knn = train(data[,3:6],data[,2], method = 'knn')
    return(modelo_knn)
  }
}

partirmensaje<-function(a){
  batch2=readRDS("Diccionary.RDS")
  mensaje=toString(a)
  trend1=trend2=GE=GC=W1=W2=matrix(NA,nrow = 1,ncol = 1)
  temp=strsplit(mensaje, split = " ")
  ntemp=unlist(temp)
  data =data.frame(Word=character(), stringsAsFactors = FALSE)
  text =data.frame(Mensaje=character(), stringsAsFactors = FALSE)
  text[1,1]=mensaje
  for (j in 1:length(ntemp)) {
    data[j,1]=ntemp[j]
  }
  t1=1
  t2=1
  w1=1
  w2=1
  for (k in 1:nrow(batch2)) {
    for (l in 1:nrow(data)) {
      if (identical(data[l,1],toString(batch2[k,1]))==TRUE) {
        t1=t1*batch2[k,2]
        t2=t2*batch2[k,3]
        w1=w1*batch2[k,4]
        w2=w2*batch2[k,5]
      }
    }
  }
  trend1[1,1]=t1
  trend2[1,1]=t2
  W1[1,1]=w1
  W2[1,1]=w2
  if (t1>t2) {
    GE[1,1]=(t1-t2)/(t1+t2)
  }
  if (t1<t2) {
    GE[1,1]=(t2-t1)/(t1+t2)
  }
  if(t1==t2){
    GE[1,1]=0
  }
  GC[1,1]=1-GE[1,1]
  finalbatch=cbind(text,trend1,trend2,GE,GC,W1,W2)
  return(finalbatch)
}

isDate <- function(fecha) {
  tryCatch(!is.na(as.Date(fecha, tryFormats = c("%Y-%m-%d", "%Y/%m/%d","%d-%m-%Y","%m-%d-%Y"))),  
           error = function(err) {FALSE})
}

connectMySQL<-function(){
  # Seleccionar driver de trabajo
  m = dbDriver("MySQL")
  # Informacion de la DB
  myHost <- "IP"
  myUsername = "USER"
  myDbname = "DBNAME"
  myPort = "PORT"
  myPassword = "PASSWORD"
  #Creacion del obj. de conexion
  con = dbConnect(m, user= myUsername, host= myHost, password= myPassword, dbname= myDbname, port= myPort)
  return(con)}

