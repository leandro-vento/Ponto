#' login UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_login_ui <- function(id){
  ns <- NS(id)
  
  tabItem(tabName = "login", align = "center",
          
          fluidRow(
            
            column(4),
            
            column(4, align = "center",
                   
                   box(width = 12,
                                       solidHeader = TRUE,
                                       status = "primary",
                                       title = "Login",
                                       align = "center",
                                       
                                       textInput(ns("usuario_login"), label = NULL, value = "", placeholder = "nome.sobrenome")
                                       
                   )
                   
            ),
            
            column(4)
            
          )
          
  )
  
}
    
#' login Server Function
#'
#' @noRd 
mod_login_server <- function(input, output, session){
  ns <- session$ns
  
  return(

    list(

      usuario = reactive({ input$usuario_login })

    )

  )
 
}
    
## To be copied in the UI
# mod_login_ui("login_ui_1")
    
## To be copied in the server
# callModule(mod_login_server, "login_ui_1")
 
