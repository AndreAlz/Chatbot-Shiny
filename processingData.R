processingData <- function(){
  getwd()
  setwd("C:/Users/practicante/Documents/shinybot")
  library(xlsx)
  batch1=read.xlsx("C:/Users/practicante/Documents/shinybot/batch.xlsx" , sheetIndex =1)
  batch2=read.xlsx("C:/Users/practicante/Documents/shinybot/batch.xlsx" , sheetIndex =2)
  
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