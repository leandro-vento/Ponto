#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # List the first level callModules here
  
  caminho <- "\\\\fgvspgvc\\ibre-sapr\\Nat\\z-Organização Anterior SIMG\\00-FUNCIONARIOS E DIVERSOS\\03_Equipe\\LEANDRO\\Ponto\\"
  
  con <- RSQLite::dbConnect(RSQLite::SQLite(), dbname = paste0(caminho, "ponto.sqlite"))
  
  tab_selecionada <- callModule(mod_menu_esquerdo_server, "menu_esquerdo_ui_1")
  
  usuario <- callModule(mod_login_server, "login_ui_1")
  
  callModule(mod_funcionarios_server, "funcionarios_ui_1", tab_selecionada = tab_selecionada, usuario = usuario, con = con)
  callModule(mod_marcacao_ponto_server, "marcacao_ponto_ui_1", usuario = usuario, con = con)
  callModule(mod_relatorios_server, "relatorios_ui_1")
}
