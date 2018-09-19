library(shiny)

shinyUI(fluidPage(
  titlePanel("Shiny Bot"),
  textInput("texto",label = "Ingrese texto"),
  actionButton("enviar", label = "Enviar"),
  textOutput("respuesta"),
  dataTableOutput("data")
  
))