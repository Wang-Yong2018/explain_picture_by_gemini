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

# Define UI for application that draws a histogram
ui <- fluidPage(
  sidebarLayout(
    NULL,
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
)

server <- function(input, output) {
  
  setAPI(Sys.getenv('gemini_api')) # check https://makersuite.google.com/app/apikey
  gemini("Explain about the gemini in astrology in one line")
  
  observeEvent(input$file, {
    path <- input$file$datapath
    output$image1 <- renderImage({
      list( src = path )
    }, deleteFile = FALSE) })
  
  observeEvent(input$goButton, {
    output$text1 <- renderText({
      gemini_image(input$prompt, input$file$datapath)
    })
  })
}

shinyApp(ui = ui, server = server)

