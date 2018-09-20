library(shiny)

shinyUI(fluidPage(
  includeScript("enter.js"),
  titlePanel("Shiny Bot"),
  textInput("texto",label = "Ingrese texto"),
  actionButton("enviar", label = "Enviar"),
  textOutput("respuesta"),
  uiOutput("fecha"),
  dataTableOutput("data")
  
))