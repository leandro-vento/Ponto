#' marcacao_ponto UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_marcacao_ponto_ui <- function(id){
  ns <- NS(id)
  tabItem(tabName = "marcacao_ponto", align = "center",
          
          fluidRow(
            
            column(8,
                   
                   box(width = 12,
                       solidHeader = TRUE,
                       status = "primary",
                       title = "Ponto",
                       align = "center",
                       
                       fluidRow(
                         
                         column(1, align = "left",
                                
                                uiOutput(ns("botao_start_stop"))
                                
                         ),
                         
                         column(4,
                                
                                htmlOutput(ns("horas_dia"))
                                
                                ),
                         
                         column(5,
                                
                                htmlOutput(ns("horas_mes"))
                                
                                ),
                         
                         column(2, align = "right",
                                
                                actionButton(ns("editar_ponto"), label = NULL, icon = icon("edit")),
                                
                                actionButton(ns("excluir_ponto"), label = NULL, icon = icon("times"))
                                
                         )
                         
                       ),
                       
                       fluidRow(
                         
                         column(12,
                                
                                DT::dataTableOutput(ns("lista_ponto"))
                                
                         )
                         
                       )
                       
                   )
                   
            ),
            
            column(4,
                   
                   box(width = 12,
                       solidHeader = TRUE,
                       status = "primary",
                       title = "Status",
                       align = "center",
                       
                       fluidRow(
                         
                         column(12, align = "left",
                                
                                actionButton(ns("atualizar_lista_online_offline"), label = NULL, icon = icon("sync"))
                                
                         )
                         
                         ),
                         
                         fluidRow(
                           
                           column(12,
                                  
                                  DT::dataTableOutput(ns("lista_online_offline"))
                                  
                           )
                         
                       )
                       
                   )
                   
            )
            
            
          )
          
  )
}
    
#' marcacao_ponto Server Function
#'
#' @noRd 
mod_marcacao_ponto_server <- function(input, output, session, usuario, con){
  ns <- session$ns
  
  con <- con
  
  # Função que converte decimal para formato hora para exibição----
  converter_decimal_para_hora <- function(tempo){
    
    horas <- as.numeric(as.integer(tempo))
    saldo1 <- tempo - horas
    minutos <- as.numeric(as.integer(saldo1*60))
    saldo2 <- saldo1 - (minutos/60)
    segundos <- as.numeric(as.integer(saldo2*3600))
    convertido <- paste0(if(nchar(horas)==1){0}, horas, ":", if(nchar(minutos)==1){0}, minutos, ":", if(nchar(segundos)==1){0}, segundos)
    convertido
    
  }
  
  # Função para atualizar as horas realizadas no dia----
  horas_dia_refresh <- function(){
    
    output$horas_dia <- renderText({
      
      FuncionarioLogado <- RSQLite::dbGetQuery(conn = con, paste0("SELECT * FROM Funcionarios WHERE Login='", usuario$usuario(), "'"))
      
      if(nrow(FuncionarioLogado) > 0){
        
        PontoFuncionario <- RSQLite::dbGetQuery(conn = con, paste0("SELECT * FROM Ponto WHERE Login='", usuario$usuario(), "' AND Data=DATE('now', 'localtime')"))
        
        horas_dia <- sum(PontoFuncionario$SaldoNumero, na.rm = TRUE)
        horas_dia <- converter_decimal_para_hora(horas_dia)
        
        paste0("<font color=\"#000000\"><b>Horas no dia: ", horas_dia, "</b></font>")
        
      }else{
        
        paste0("")
        
      }
      
    })
    
  }
  
  horas_dia_refresh()
  
  # Função para atualizar as horas realizadas no mês----
  horas_mes_refresh <- function(){
    
    output$horas_mes <- renderText({
      
      FuncionarioLogado <- RSQLite::dbGetQuery(conn = con, paste0("SELECT * FROM Funcionarios WHERE Login='", usuario$usuario(), "'"))
      
      if(nrow(FuncionarioLogado) > 0){
        
        PontoFuncionario <- RSQLite::dbGetQuery(conn = con, paste0("SELECT * FROM Ponto WHERE Login='", usuario$usuario(), "' AND strftime('%M/%Y', Data)=strftime('%M/%Y', DATE('now', 'localtime'))"))
        
        horas_mes <- sum(PontoFuncionario$SaldoNumero, na.rm = TRUE)
        horas_mes <- converter_decimal_para_hora(horas_mes)
        
        paste0("<font color=\"#000000\"><b>Horas no mês: ", horas_mes, "</b></font>")
        
      }else{
        
        paste0("")
        
      }
      
    })
    
  }
  
  horas_mes_refresh()
  
  # Função que exibe a lista dos funcionários que estão online e offline----
  lista_online_offline_refresh <- function(){
    
    output$lista_online_offline <- DT::renderDataTable(DT::datatable({
      
      ListaFuncionarios <- RSQLite::dbGetQuery(conn = con, "SELECT * FROM Funcionarios")
      
      ListaPonto <- RSQLite::dbGetQuery(conn = con, paste0("SELECT DISTINCT Login, Status FROM Ponto WHERE Status='online'"))
      
      ListaFuncionarios <- dplyr::select(ListaFuncionarios, Login, Nome, HorasDiarias, Equipe)
      ListaFuncionarios <- dplyr::right_join(ListaPonto, ListaFuncionarios, by = "Login")
      ListaFuncionarios <- dplyr::select(ListaFuncionarios, Nome, Status)
      ListaFuncionarios$Status <- ifelse(is.na(ListaFuncionarios$Status), "offline", ListaFuncionarios$Status)
      ListaFuncionarios
    }, options = list(pageLength = 27, dom = "tp", scrollX = TRUE, scrollY = TRUE), colnames = c("Nome", "Status"), rownames = FALSE, selection = "single") %>% 
      DT::formatStyle("Status", target = 'row',
                      backgroundColor = DT::styleEqual(c("online", "offline"), c("green", "red")))
    
    
    )
    
    
  }
  
  lista_online_offline_refresh()
  
  # Evento para atualizar a lista online-offline----
  observeEvent(input$atualizar_lista_online_offline, {
    
    lista_online_offline_refresh()
    
  })
  
  # Verificação para renderizar o botão de play ou stop----
  observe({
    
    FuncionarioLogado <- RSQLite::dbGetQuery(conn = con, paste0("SELECT * FROM Ponto WHERE Login='", usuario$usuario(), "' AND Status='online'"))
    
    if(nrow(FuncionarioLogado) > 0){
      
      output$botao_start_stop <- renderUI({
        
        actionButton(ns("adicionar_ponto"), label = NULL, icon = icon("stop"))
        
      })
      
    }else{
      
      output$botao_start_stop <- renderUI({
        
        actionButton(ns("adicionar_ponto"), label = NULL, icon = icon("play"))
        
      })
      
    }
    
  })
  
  # Função que atualiza a lista de ponto do funcionário----
  lista_ponto_refresh <- function(){
    
    output$lista_ponto <- DT::renderDataTable(DT::datatable({
      
      ListaPonto <- RSQLite::dbGetQuery(conn = con, paste0("SELECT * FROM Ponto WHERE Login='", usuario$usuario(), "' AND Data=DATE('now', 'localtime')"))
      
      ListaPonto <- dplyr::select(ListaPonto, Entrada, Saida, SaldoHora)
      
      ListaPonto
      
    }, options = list(pageLength = 27, dom = "tp", scrollX = TRUE, scrollY = TRUE), colnames = c("Entrada", "Saida", "Saldo"), rownames = FALSE, selection = "single"))
    
    
  }
  
  # Função que exibe a lista de ponto se o usuário está logado----
  observe({
    
    FuncionarioLogado <- RSQLite::dbGetQuery(conn = con, paste0("SELECT * FROM Funcionarios WHERE Login='", usuario$usuario(), "'"))
    
    if(nrow(FuncionarioLogado) > 0){
      
      lista_ponto_refresh()
      
    }
    
  })
  
  # Evento para adicionar uma nova marcação no ponto----
  observeEvent(input$adicionar_ponto, {
    
    FuncionarioLogado <- RSQLite::dbGetQuery(conn = con, paste0("SELECT * FROM Funcionarios WHERE Login='", usuario$usuario(), "'"))
    
    if(nrow(FuncionarioLogado) > 0){
      
      ListaPontoFuncionarioData <- RSQLite::dbGetQuery(conn = con, paste0("SELECT * FROM Ponto WHERE Login='", usuario$usuario(), "' AND Data=DATE('now', 'localtime')"))
      
      # Inserir nova Entrada
      if(nrow(ListaPontoFuncionarioData) == 0){
        
        RSQLite::dbSendQuery(con, paste0("INSERT INTO Ponto (Login, Data, Entrada, Status) VALUES ('", usuario$usuario(), "', DATE('now', 'localtime'), TIME('now', 'localtime'), 'online')"))
        
        output$botao_start_stop <- renderUI({
          
          actionButton(ns("adicionar_ponto"), label = NULL, icon = icon("stop"))
          
        })
        
        lista_online_offline_refresh()
        
      }
      # Se o funcionario marcou o ponto no dia
      else if(nrow(ListaPontoFuncionarioData) > 0){
        
        ListaPontoFuncionarioDataEntradaSaida <- RSQLite::dbGetQuery(conn = con, paste0("SELECT * FROM Ponto WHERE Login='", usuario$usuario(), "' AND Data=DATE('now', 'localtime') AND Status='online'"))
        
        # Inserir Saída
        if(nrow(ListaPontoFuncionarioDataEntradaSaida) > 0){
          
          RSQLite::dbSendQuery(con, paste0("UPDATE Ponto SET Saida = TIME('now', 'localtime'), Status = 'offline', SaldoNumero = (CAST((strftime('%s', TIME('now', 'localtime'))-strftime('%s', Entrada)) AS REAL)/3600), SaldoHora = '' WHERE Login='", usuario$usuario(), "' AND Data=DATE('now', 'localtime') AND Saida IS NULL"))
          
          SaldoNumero <- RSQLite::dbGetQuery(conn = con, paste0("SELECT * FROM Ponto WHERE Login='", usuario$usuario(), "' AND Data=DATE('now', 'localtime') AND Status='offline' AND SaldoHora=''"))
          SaldoHora <- converter_decimal_para_hora(SaldoNumero$SaldoNumero)
          RSQLite::dbSendQuery(con, paste0("UPDATE Ponto SET SaldoHora = '", SaldoHora, "' WHERE Login='", usuario$usuario(), "' AND Data=DATE('now', 'localtime') AND SaldoHora = ''"))
          
          
          output$botao_start_stop <- renderUI({
            
            actionButton(ns("adicionar_ponto"), label = NULL, icon = icon("play"))
            
          })
          
          lista_online_offline_refresh()
          horas_dia_refresh()
          horas_mes_refresh()
          
        }
        # Inserir nova Entrada
        else{
          
          RSQLite::dbSendQuery(con, paste0("INSERT INTO Ponto (Login, Data, Entrada, Status) VALUES ('", usuario$usuario(), "', DATE('now', 'localtime'), TIME('now', 'localtime'), 'online')"))
          
          output$botao_start_stop <- renderUI({
            
            actionButton(ns("adicionar_ponto"), label = NULL, icon = icon("stop"))
            
          })
          
          lista_online_offline_refresh()
          
        }
        
      }
      
    }
    
    lista_ponto_refresh()
    
  })
  
  # Evento para Editar a marcação no ponto----
  observeEvent(input$editar_ponto, {
    
    
    
  })
  
  # Evento para Excluir a marcação no ponto----
  observeEvent(input$excluir_ponto, {
    
    
    
  })
  
}
    
## To be copied in the UI
# mod_marcacao_ponto_ui("marcacao_ponto_ui_1")
    
## To be copied in the server
# callModule(mod_marcacao_ponto_server, "marcacao_ponto_ui_1")
 
