library(shiny)
shinyUI(fluidPage(
  titlePanel("Shiny Bot"),
  textInput("texto",label = "ingrese mensaje"),
  actionButton("enviar", label = "enviar"),
  textOutput("resp")
))