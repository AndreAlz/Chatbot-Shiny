library(shiny)
shinyUI(fluidPage(
  includeScript("enter.js"),
  titlePanel("Shiny Bot"),
  sidebarPanel(
    wellPanel(
      fluidRow(
        textInput("texto",label = "Ingrese texto"),
        actionButton("enviar", label = "Enviar")
      )
    ),
    fluidRow(
      wellPanel(
        textOutput("respuesta")
      )
    )
  ),
  mainPanel(
    wellPanel(
      dataTableOutput("data")
    )
  )
))