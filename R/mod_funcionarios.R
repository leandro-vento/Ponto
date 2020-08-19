#' funcionarios UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_funcionarios_ui <- function(id){
  ns <- NS(id)
  tabItem(tabName = "funcionarios", align = "center",
          
          fluidRow(
            
            column(12,
                   
                   box(width = 12,
                       solidHeader = TRUE,
                       status = "primary",
                       title = "Funcionários",
                       align = "center",
                       
                       fluidRow(
                         
                         column(12, align = "left",
                                
                                actionButton(ns("adicionar_funcionario"), label = NULL, icon = icon("plus")),
                                actionButton(ns("excluir_funcionario"), label = NULL, icon = icon("times"))
                                
                                )
                         
                       ),
                       
                       fluidRow(
                         
                         column(12,
                         
                         DT::dataTableOutput(ns("lista_funcionarios"))
                         
                         )
                         
                       )
                       
                   )
                   
            )
            
          )
          
  )
  
}
    
#' funcionarios Server Function
#'
#' @noRd 
mod_funcionarios_server <- function(input, output, session, tab_selecionada, usuario, con){
  ns <- session$ns
  
  con <- con
  
  session$onSessionEnded(function(session){
    
    RSQLite::dbDisconnect(con)
    
  })
  
  lista_funcionarios_refresh <- function(){
    
    output$lista_funcionarios <- DT::renderDataTable(DT::datatable({
      
      ListaFuncionarios <- RSQLite::dbGetQuery(conn = con, "SELECT * FROM Funcionarios")
      
      ListaPonto <- RSQLite::dbGetQuery(conn = con, paste0("SELECT DISTINCT Login, Status FROM Ponto WHERE Status='online'"))
      
      ListaFuncionarios <- dplyr::select(ListaFuncionarios, Login, Nome, HorasDiarias, Equipe)
      ListaFuncionarios
      
    }, options = list(pageLength = 27, dom = "tp", scrollX = TRUE, scrollY = TRUE), colnames = c("Login", "Nome", "Horas Diarias", "Equipe"), rownames = FALSE, selection = "single")
    
    
    )
    
    
  }
  
  lista_funcionarios_vazia_refresh <- function(){
    
    output$lista_funcionarios <- DT::renderDataTable(DT::datatable({
      
      data.frame(col1 = c(""),
                 col2 = c(""),
                 col3 = c(""),
                 col4 = c(""),
                 Status = c(""))
      
      
    }, options = list(pageLength = 27, dom = "tp", scrollX = TRUE, scrollY = TRUE), colnames = c("Login", "Nome", "Horas Diarias", "Equipe", "Status"), rownames = FALSE, selection = "single") %>% 
      DT::formatStyle("Status", target = 'row',
                      backgroundColor = DT::styleEqual(c("online", "offline"), c("green", "red")))
    
    
    )
    
    
  }
  
  
  tab <- reactive({

    c <- tab_selecionada$tab_selecionada()

    return(c)

  })

  observe({

    if(tab() == "funcionarios"){

      FuncionarioLogado <- RSQLite::dbGetQuery(conn = con, paste0("SELECT * FROM Funcionarios WHERE Login='", usuario$usuario(), "'"))
      
      if(nrow(FuncionarioLogado) > 0){
        
        lista_funcionarios_refresh()
        
      }else{
        
        lista_funcionarios_vazia_refresh()
        
      }

    }

  })
  
  observe({
    
    ListaFuncionarios <- RSQLite::dbGetQuery(conn = con, "SELECT * FROM Funcionarios")
    FuncionarioLogado <- RSQLite::dbGetQuery(conn = con, paste0("SELECT * FROM Funcionarios WHERE Login='", usuario$usuario(), "'"))
    
    if(nrow(FuncionarioLogado) > 0){
      
      lista_funcionarios_refresh()
      
    }
    
  })
 
}
    
## To be copied in the UI
# mod_funcionarios_ui("funcionarios_ui_1")
    
## To be copied in the server
# callModule(mod_funcionarios_server, "funcionarios_ui_1")
 
