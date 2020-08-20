#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  
  library(shinydashboard)
  library(shinydashboardPlus)
  library(shinyjs)
  library(shinyWidgets)
  library(dplyr)
  library(DT)
  library(lubridate)
  
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    dashboardPagePlus(
      skin = "blue-light",
      title = "Sistema de Gestão de Horário",
      enable_preloader = TRUE,
      loading_duration = 1,
      dashboardHeaderPlus(
        title =  tagList(
          span(class = "logo-lg", "Sistema de Gestão de Horário"), 
          img(src = "https://simuladorcmg-ibre.fgv.br/iconFGV2.ico", width = "180%")),
        
        fixed = FALSE,
        tags$li(img(src = "https://simuladorcmg-ibre.fgv.br/logo_fgv2.png", height = "20px", 
                    style = "margin-top:15px;margin-right:10px;"), class = "dropdown")
        # ,
        # left_menu = list(
        #   
        #   mod_inicio_ui("inicio_ui_1")
        #   
        # )
      ),
      dashboardSidebar(
        
        mod_menu_esquerdo_ui("menu_esquerdo_ui_1")
        
      ),
      dashboardBody(
        useShinyjs(),
        tags$style(HTML("
                      
                      .skin-blue-light .main-header .navbar{
      
      background-color: #002d4d;
      
      }
      
      .skin-blue-light .main-header .logo{
      
      background-color: #002d4d;
      
      }
      
      .skin-blue-light .main-header .logo:hover{
      
      background-color: #002d4d;
      
      }
      
      .skin-blue-light .main-header .navbar .sidebar-toggle:hover{
      
      background-color: #002d4d;
      
      }
      .box.box-solid.box-primary>.box-header {

      background-color: #002d4d;
      
      }
      .alert-info, .bg-aqua, .callout.callout-info, .label-info, .modal-info .modal-body {
          background-color: #002d4d;
      }
      .main-header{
      position: fixed;
      width:100%;
      }
      .main-sidebar {
      position: fixed;
      white-space: nowrap;
      overflow: visible;
      }
      .content {
      margin-top: 50px;
      padding-bottom: 54px;
      }
      .main-header .logo{
      font-weight: bold;
      font-size: 12px;
      }
      .skin-blue-light .sidebar-menu>li.active>a {
      
      background-color: #002d4d;
      color: #FFFFFF;
      
      }

      .skin-blue-light .sidebar-menu .treeview-menu>li>a {
      
      color: #000000;
      
      }

      .skin-blue-light .sidebar-menu .treeview-menu>li>a:hover {
      
      background-color: #002d4d;
      color: #FFFFFF;
      
      }
      .skin-blue-light .sidebar-menu>li a:hover {
      
      background-color: #002d4d;
      color: #FFFFFF;
      
      }
      
      .tab-content {
      
      width: 100%;
      height: 100%;
      
      }
      
      .bootstrap-switch .bootstrap-switch-handle-off.bootstrap-switch-primary, .bootstrap-switch .bootstrap-switch-handle-on.bootstrap-switch-primary {
      
      background: transparent;
      
      }
      
    ")),
        tags$head(tags$style("#carregando .modal-body {padding: 1px}
                       #carregando .modal-content  {
                       -webkit-border-radius: 6px !important;
                       -moz-border-radius: 6px !important;
                       border-radius: 6px !important;
                       opacity: 1;
                       filter: alpha(opacity=1);
                       height: 20px;
                       }
                       #carregando .modal-dialog {
                       opacity: 0;
                       filter: alpha(opacity=0);
                       width: 300px;
                       top:40%;
                       align-items: left;
                       flex-direction: row;
                       flex-wrap: wrap;
                       justify-content: center;
                       opacity: 1;
                       filter: alpha(opacity=100);
                       }
                       #carregando .modal-header {
                       background-color: #339FFF;
                       border-top-left-radius: 6px;
                       border-top-right-radius: 6px;
                       }
                       #carregando .modal {
                       text-align: center;
                       padding-right:0px;
                       padding-top: 0px;
                       opacity: 1;
                       filter: alpha(opacity=100);
                       }
                      .progress-group {
                      border: 0px;
                      padding-top: 0px;
                      padding-left: 0px;
                       -webkit-border-radius: 6px !important;
                       -moz-border-radius: 6px !important;
                       border-radius: 6px !important;
                       vertical-align: middle;
                                           
                      }
                      .progress {
                      border: 0px;
                      padding-top: 0px;
                      padding-left: 0px;
                           height: 18px;
                       -webkit-border-radius: 6px !important;
                       -moz-border-radius: 6px !important;
                       border-radius: 6px !important;
                       vertical-align: middle;
                                           
                      }
                      #pb4 {
                       vertical-align: middle;
                                           
                      }
                      
                      .modal-content {
                      
                        border-radius: 50%;
                      
                      }
                      
                      .modal-body{
                      
                        padding: 0px;
                      
                      }
                      
                      .modal-sm{
                      
                        width: 60px;
                      
                      }
                      
                      .double-bounce1{
                      
                      background-color: #002d4d;
                      
                      }
                      
                      .double-bounce2{
                      
                      background-color: #002d4d;
                      
                      }
                      
                      .loaded{
                      
                      padding-right: 0px;
                      
                      }
                      
                      .skin-blue-light sidebar-mini loaded{
                      
                      padding-right: 0px;
                      
                      }
                      
                      .bttn-stretch.bttn-primary {
                      color: #000000;
                                           
                      }
                      .bttn-simple.bttn-primary {
                      color: #000000;
                      background-color: #FFFFFF;
                                           
                      }
                      .shiny-download-link {
                      color: #000000;
                      background-color: transparent;
                      border: none;
                      font-size: 20px;
                                           
                      }
                      .action-button {
                      color: #000000;
                      background-color: transparent;
                      border: 1px;
                      font-size: 20px;
                                           
                      }
                      #entrar_login {
                      color: #002d4d;
                      background-color: transparent;
                      border: 1px solid #002d4d;
                      font-size: 15px;
                                           
                      }
                      .bootstrap-switch {
                      
                      height: 30px;
                      margin-bottom: -13px;
                      
                      }
                      ")),
        
        tags$head(tags$style("#modal1 .modal-content { background-color: transparent; }")),
        
        tabItems(
          
          mod_login_ui("login_ui_1"),
          mod_funcionarios_ui("funcionarios_ui_1"),
          mod_marcacao_ponto_ui("marcacao_ponto_ui_1"),
          mod_relatorios_ui("relatorios_ui_1")
          
        )
      )
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'Ponto'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

