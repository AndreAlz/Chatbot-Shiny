library(shiny)library(DBI)
library(RMySQL)
library(xlsx)
library(caret)

shinyUI(fluidPage(
  titlePanel("Shiny Bot"),
  textInput("texto",label = "ingrese mensaje"),
  actionButton("enviar", label = "enviar"),
  textOutput("resp")
))