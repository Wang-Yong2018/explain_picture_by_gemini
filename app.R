#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#



library(shiny)
library(gemini.R)
source('utils.R')


# Define UI for application that draws a histogram
ui <- fluidPage(
  sidebarLayout(
    NULL,
    mainPanel(
      mainPanel(
       
      fileInput(
        inputId = 'file',
        label = 'Choose file to upload',
      ),
      div(
        style = 'border: solid 1px blue;',
        imageOutput(outputId = 'image1',
                    width='100%',
                    height='100%'),
      ),
      textOutput('server_status' ),
      textInput(
        inputId = 'prompt',
        label = 'Prompt',
        placeholder = 'Enter Prompts Here'
      ),
      actionButton('goButton', 'Ask to gemini'),
      div(
        style = 'border: solid 1px blue; min-height: 100px;',            textOutput('text1')
      )
    )
  )
))

server <- function(input, output) {
  
  setAPI(Sys.getenv('gemini_api')) # check https://makersuite.google.com/app/apikey
 
  
  output$server_status<- renderText({
    status_code <- get_server_status_code()
    message <- paste0(
      "server connection:",
      status_code
    )
    return(message)
  })
  
  observeEvent(input$file, {
    path <- input$file$datapath
    output$image1 <- renderImage({
      list( src = path )
    }, deleteFile = FALSE) })
  
  observeEvent(input$goButton, {
    output$text1 <- renderText({
      print("\n==========================")
      print(paste0(' input is :',input$prompt))
      message <-  gemini_image(input$prompt, input$file$datapath)
      if (is.null(message)){
        message <- 'failed to detect!!!'
      }
      print("**************************")
      print(paste0(' output is :',message))
    
      return(message)
    })
  })
}

shinyApp(ui = ui, server = server)

