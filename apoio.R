caminho <- "C:\\Users\\leand\\OneDrive - FGV\\Ponto\\"
con <- RSQLite::dbConnect(RSQLite::SQLite(), dbname = paste0(caminho, "ponto.sqlite"))
Funcionarios <- data.frame(Id = c(1, 2, 3),
                           Login = c("leandro.vento", "lucas.cardoso", "vitoria.souza"),
                           Nome = c("Leandro Vigari Vento", "Lucas Cardoso de Menezes", "Vitória Silva de Souza"),
                           HorasDiarias = c(8, 8, 8),
                           Equipe = c("Assessoria de TI e Suporte", "Assessoria de TI e Suporte", "Assessoria de TI e Suporte"),
                           stringsAsFactors = FALSE)
RSQLite::dbWriteTable(conn = con, name = "Funcionarios", value = Funcionarios, overwrite = TRUE)
RSQLite::dbListTables(con)

Ponto <- data.frame(Login = c("leandro.vento"),
                    Data = c(as.Date(x = Sys.Date(), format = "%d/%m/%Y")),
                    Entrada = c(as.Date(x = Sys.time(), format = "%H:%M")),
                    Saida = c(""),
                    Saldo = c(""),
                    Referencia = c(""),
                    Status = c(""),
                    stringsAsFactors = FALSE)
RSQLite::dbWriteTable(conn = con, name = "Ponto", value = Ponto, overwrite = TRUE)
RSQLite::dbListTables(con)

ListaPonto <- RSQLite::dbGetQuery(conn = con, "SELECT * FROM Ponto")
RSQLite::dbSendQuery(con, paste0("INSERT INTO Ponto (Data, Status) VALUES (DATE(), 'online')"))
RSQLite::dbSendQuery(con, paste0("INSERT INTO Ponto (Entrada, Status) VALUES (TIME(), 'online')"))
RSQLite::dbSendQuery(con, paste0("DROP TABLE Ponto"))
RSQLite::dbSendQuery(conn = con,
                     "CREATE TABLE Ponto (
                     id integer primary key autoincrement,
                     Login text,
                     Data data_type,
                     Entrada data_type,
                     Saida data_type,
                     SaldoHora text,
                     SaldoNumero real,
                     Referencia data_type,
                     Status text
                     )")
RSQLite::dbDisconnect(con)

converter_decimal_para_hora <- function(tempo){
  
  horas <- as.numeric(as.integer(tempo))
  saldo1 <- tempo - horas
  minutos <- as.numeric(as.integer(saldo1*60))
  saldo2 <- saldo1 - (minutos/60)
  segundos <- as.numeric(as.integer(saldo2*3600))
  convertido <- paste0(if(nchar(horas)==1){0}, horas, ":", if(nchar(minutos)==1){0}, minutos, ":", if(nchar(segundos)==1){0}, segundos)
  convertido
}

converter_decimal_para_hora(8.75)
