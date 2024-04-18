library(gemini.R)
library(httr)

get_server_status_code<-function(){
  
  if (Sys.getenv("GEMINI_API_KEY") == "") {
    cat("Please set the GEMINI_API_KEY environment variable with setAPI function.\n")
    return(NULL)
  }
  model_query <- "gemini-pro:generateContent"
  prompt <- 'tell about the current used gemini version'
  response <- POST(
    url = paste0("https://generativelanguage.googleapis.com/v1beta/models/", model_query),
    query = list(key = Sys.getenv("GEMINI_API_KEY")),
    content_type_json(),
    encode = "json",
    body = list(
      contents = list(
        parts = list(
          list(text = prompt)
        )
      ),
      generationConfig = list(
        temperature = 0.5,
        maxOutputTokens = 1024
      )
    )
  )
  #candidates <- content(response)$candidates
  #outputs <- unlist(lapply(candidates, function(candidate) candidate$content$parts))
  output <- response$status_code
  if(output != 200)
  {
    print(paste0("Fatal Error!!!", date()))
    print(content(response))
    
    }
  
  return(output)
  
}