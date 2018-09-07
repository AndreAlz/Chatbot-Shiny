library(shiny)
setwd('~/shinybot')
shinyUI(fluidPage(
  titlePanel("Shiny Bot"),
  textInput("texto",label = "ingrese mensaje"),
  actionButton("enviar", label = "enviar"),
  textOutput("resp")
))