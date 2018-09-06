creaModelknn <- function(){
  library(caret)
  source("processingData.R")
  
  data=processingData()
  data$Resultado=as.factor(data$Resultado)
  set.seed(6666)

  modelo_knn = train(data[,3:6],data[,2], method = 'knn')
return(modelo_knn)
}