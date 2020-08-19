#' relatorios UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_relatorios_ui <- function(id){
  ns <- NS(id)
  tabItem(tabName = "relatorios", align = "center",
          
          fluidRow(
            
            column(4),
            
            column(4,
                   
                   box(width = 12,
                                       solidHeader = TRUE,
                                       status = "primary",
                                       title = "Relatórios",
                                       align = "center"
                                       
                   )
                   
            ),
            
            column(4)
            
          )
          
  )
}
    
#' relatorios Server Function
#'
#' @noRd 
mod_relatorios_server <- function(input, output, session){
  ns <- session$ns
 
}
    
## To be copied in the UI
# mod_relatorios_ui("relatorios_ui_1")
    
## To be copied in the server
# callModule(mod_relatorios_server, "relatorios_ui_1")
 
