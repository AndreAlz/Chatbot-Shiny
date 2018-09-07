library(shiny)
# library(DBI)
# library(RMySQL)
# library(xlsx)
# library(caret)

ui <- fluidPage(
  titlePanel("Shiny Bot"),
  textInput("texto",label = "ingrese mensaje"),
  actionButton("enviar", label = "enviar")
  # textOutput("resp")
)
server <- function(input, output,session) {
#   source("crcoan.R")
#   mknn=creaModelknn()
#   mensaje=eventReactive(input$enviar,input$texto)
#   pre=reactiveVal(0)
#   interact=0
#   observeEvent(input$enviar,{
#     if (interact==0) {
#       data=partirmensaje(mensaje())
#       newvalue=predict(mknn,data[,2:5])
#       pre(newvalue)
#       updateTextInput(session,inputId = "texto", value = "")
#     }
#   })
#   
#   observeEvent(pre(),{
#     valo=as.numeric(pre())
#     if(valo==1){
#       output$resp=renderText("ok pero necesito tu numero de ticket")
#       interact<<-1
#     }
#     if(valo==2){
#       output$resp=renderText("desde que fecha")
#       interact<<-1
#     }
#   })
#   observeEvent(input$enviar,{
#     updateTextInput(session,inputId = "texto", value = "")
#     if(interact==1){
#       valo=as.numeric(pre())
#       if(valo==1){
#         output$resp=renderText("tipo 2.1")
#       }
#       if(valo==2){
#         output$resp=renderText("tipo 2.2")
#       }
#       interact<<-0
#       pre(0)
#     }
#   })
}
# shinyApp(ui = ui, server = server)