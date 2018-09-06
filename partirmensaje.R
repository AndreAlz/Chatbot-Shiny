partirmensaje<-function(a){
getwd()
setwd("C:/Users/practicante/Documents/shinybot")
library(xlsx)
batch2=read.xlsx("C:/Users/practicante/Documents/shinybot/batch.xlsx" , sheetIndex =2)
# b=read.xlsx("C:/Users/practicante/Documents/Chat-botv2/batch.xlsx" , sheetIndex =3)
# # mensaje=toString(b[1,1])
mensaje=toString(a)
trend1=trend2=GE=GC=matrix(NA,nrow = 1,ncol = 1)
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
for (k in 1:nrow(batch2)) {
    for (l in 1:nrow(data)) {
      if (identical(data[l,1],toString(batch2[k,1]))==TRUE) {
        t1=t1*batch2[k,2]
        t2=t2*batch2[k,3]
      }
    }
}
  trend1[1,1]=t1
  trend2[1,1]=t2
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
  finalbatch=cbind(text,trend1,trend2,GE,GC)
  return(finalbatch)
}