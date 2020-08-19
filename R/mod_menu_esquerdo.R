#' menu_esquerdo UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_menu_esquerdo_ui <- function(id){
  ns <- NS(id)
  sidebarMenu(id = ns("tabs"),
              menuItem("Login", tabName = "login", icon = icon("gears")),
              menuItem("Funcionários", tabName = "funcionarios", icon = icon("table")),
              menuItem("Marcação de Ponto", tabName = "marcacao_ponto", icon = icon("clipboard-list")),
              menuItem("Relatórios", tabName = "relatorios", icon = icon("poll"))
  )
}
    
#' menu_esquerdo Server Function
#'
#' @noRd 
mod_menu_esquerdo_server <- function(input, output, session){
  ns <- session$ns
  
  return(
    
    list(
      
      tab_selecionada = reactive({ input$tabs })
      
    )
    
  )
 
}
    
## To be copied in the UI
# mod_menu_esquerdo_ui("menu_esquerdo_ui_1")
    
## To be copied in the server
# callModule(mod_menu_esquerdo_server, "menu_esquerdo_ui_1")
 
