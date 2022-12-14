# Tabela Total ------------------------------------------------------------
#' pnadc_total
#'
#' @description Creates PNADc totals tables for one or more variables. Tables can be generated in \R or exported using the "export" option
#' @description [Documentation in English](https://github.com/migux14/PNADc.table/tree/main/vignettes)
#' @description [Documentation in Portuguese - BR](https://github.com/migux14/PNADc.table/tree/main/Documents%20PT-BR)
#'
#' @param variable Variable of interest that will be used to calculate the Total. It can be a vector of variables.
#' @param filter Variable that defines the aggregation level of the variable of interest. It can contain more than one level of aggregation.
#' @param year The year you want to review. Must be a number between 2012 and the current year. It does not accept a vector of years.
#' @param quartile The quartile of the year you want to analyze. Must be a number between 1 and 4. It does not accept a vector of quartiles.
#' @param path Path to the directory where the Design was created through the "pnadc_download" function.
#' @param export Export the table to "html", "pdf" and "png" formats. If you want to return a data frame in R space, use "df". If it has not been filled, it returns a gt table in R space. It must be a string and be enclosed in " ".
#'
#' @importFrom gt tab_header
#' @importFrom gt md
#' @importFrom gt tab_options
#' @importFrom gt tab_source_note
#' @importFrom gt sub_missing
#' @importFrom utils write.csv2
#' @importFrom gt gtsave
#'
#' @return gt table.
#'
#' @examples \donttest{pnadc_total(~V403312, ~UF+V2010, 2019, 1)}
pnadc_total <- function(variable, filter, year, quartile, path = FALSE, export = FALSE) {
  design_PNADc <- NULL
  if (path == FALSE) {
    if (file.exists(fs::path_home(paste("Design","PNADc", year, quartile, sep = "_"))) == TRUE) {
      Design <- paste("Design","PNADc", year, quartile, sep = "_")
      load(fs::path_home(Design))

      tabela <- survey::svyby(formula = variable, by = filter, design = design_PNADc, FUN = survey::svytotal, na.rm = TRUE, na.rm.by = TRUE, na.rm.all = TRUE)
      tabela <- as.data.frame(tabela)

      rm(design_PNADc)
      gc()

      grupo <- as.character(filter)
      grupo <- unlist(strsplit(grupo, split = " "))

      if (length(grupo) > 3) {
        tabela_final <- gt::gt(tabela, groupname_col = grupo[4]) %>%
          tab_header(
            title = md(paste(variable))
          ) %>%
          tab_options(
            table.align = "left",
            heading.background.color = "lightblue3",
            column_labels.background.color = "lightcyan",
            stub.background.color = "lightcyan",
            source_notes.background.color = "lightcyan"
          ) %>%
          tab_source_note(
            source_note = md(paste("Dados da PNADc ", year,".", quartile, sep = "" ))
          ) %>%
          sub_missing(
            columns = 1:ncol(tabela),
            missing_text = "Grand total")
      } else {
        tabela_final <- gt::gt(tabela) %>%
          tab_header(
            title = md(paste(variable))
          ) %>%
          tab_options(
            table.align = "left",
            heading.background.color = "lightblue3",
            column_labels.background.color = "lightcyan",
            stub.background.color = "lightcyan",
            source_notes.background.color = "lightcyan"
          ) %>%
          tab_source_note(
            source_note = md(paste("Dados da PNADc ", year,".", quartile, sep = "" ))
          ) %>%
          sub_missing(
            columns = 1:ncol(tabela),
            missing_text = "Grand total")
      }

      if (export == FALSE) {
        return(tabela_final)
      }
      if (export == "df") {
        return(tabela)
      }
      if (export == "csv") {
        utils::write.csv2(tabela_final, file = paste(fs::path_home(),"/Tabela_pnadc_total_", year, "_", quartile,".csv", sep = ""))
        message(paste("Saved in directory: ",fs::path_home(), sep = ""))
      } else {
        gt::gtsave(tabela_final, filename = paste("Tabela_pnadc_total_", year, "_", quartile,".", export, sep = ""), path = fs::path_home())
        message(paste("Saved in directory: ",fs::path_home(), sep = ""))
      }

      rm(list = c("tabela", "tabela_final", "grupo"))
      gc(reset = TRUE)
    }
    else {
      pnadc_download(year = year, quartile = quartile)

      Design <- paste("Design","PNADc", year, quartile, sep = "_")
      load(fs::path_home(Design))

      tabela <- survey::svyby(formula = variable, by = filter, design = design_PNADc, FUN = survey::svytotal, na.rm = TRUE, na.rm.by = TRUE, na.rm.all = TRUE)
      tabela <- as.data.frame(tabela)

      rm(design_PNADc)
      gc()

      grupo <- as.character(filter)
      grupo <- unlist(strsplit(grupo, split = " "))

      if (length(grupo) > 3) {
        tabela_final <- gt::gt(tabela, groupname_col = grupo[4]) %>%
          tab_header(
            title = md(paste(variable))
          ) %>%
          tab_options(
            table.align = "left",
            heading.background.color = "lightblue3",
            column_labels.background.color = "lightcyan",
            stub.background.color = "lightcyan",
            source_notes.background.color = "lightcyan"
          ) %>%
          tab_source_note(
            source_note = md(paste("Dados da PNADc ", year,".", quartile, sep = "" ))
          ) %>%
          sub_missing(
            columns = 1:ncol(tabela),
            missing_text = "Grand total")
      } else {
        tabela_final <- gt::gt(tabela) %>%
          tab_header(
            title = md(paste(variable))
          ) %>%
          tab_options(
            table.align = "left",
            heading.background.color = "lightblue3",
            column_labels.background.color = "lightcyan",
            stub.background.color = "lightcyan",
            source_notes.background.color = "lightcyan"
          ) %>%
          tab_source_note(
            source_note = md(paste("Dados da PNADc ", year,".", quartile, sep = "" ))
          ) %>%
          sub_missing(
            columns = 1:ncol(tabela),
            missing_text = "Grand total")
      }

      if (export == FALSE) {
        return(tabela_final)
      }
      if (export == "df") {
        return(tabela)
      }
      if (export == "csv") {
        utils::write.csv2(tabela_final, file = paste(fs::path_home(),"/Tabela_pnadc_total_", year, "_", quartile,".csv", sep = ""))
        message(paste("Saved in directory: ",fs::path_home(), sep = ""))
      } else {
        gt::gtsave(tabela_final, filename = paste("Tabela_pnadc_total_", year, "_", quartile,".", export, sep = ""), path = fs::path_home())
        message(paste("Saved in directory: ",fs::path_home(), sep = ""))
      }
      rm(list = c("tabela", "tabela_final", "grupo"))
      gc(reset = TRUE)
    }
  }
  else {
    path_file <- fs::path_home(paste("path_PNADcTABLE", year, quartile, sep = "_"))

    if (file.exists(path_file) == TRUE) {
      load(path_file)
      local_file <- paste(path, "/design_PNADc_", year, "_", quartile, sep = "")
      load(local_file)

      tabela <- survey::svyby(formula = variable, by = filter, design = design_PNADc, FUN = survey::svytotal, na.rm = TRUE, na.rm.by = TRUE, na.rm.all = TRUE)
      tabela <- as.data.frame(tabela)

      rm(design_PNADc)
      gc()

      grupo <- as.character(filter)
      grupo <- unlist(strsplit(grupo, split = " "))

      if (length(grupo) > 3) {
        tabela_final <- gt::gt(tabela, groupname_col = grupo[4]) %>%
          tab_header(
            title = md(paste(variable))
          ) %>%
          tab_options(
            table.align = "left",
            heading.background.color = "lightblue3",
            column_labels.background.color = "lightcyan",
            stub.background.color = "lightcyan",
            source_notes.background.color = "lightcyan"
          ) %>%
          tab_source_note(
            source_note = md(paste("Dados da PNADc ", year,".", quartile, sep = "" ))
          ) %>%
          sub_missing(
            columns = 1:ncol(tabela),
            missing_text = "Grand total")
      } else {
        tabela_final <- gt::gt(tabela) %>%
          tab_header(
            title = md(paste(variable))
          ) %>%
          tab_options(
            table.align = "left",
            heading.background.color = "lightblue3",
            column_labels.background.color = "lightcyan",
            stub.background.color = "lightcyan",
            source_notes.background.color = "lightcyan"
          ) %>%
          tab_source_note(
            source_note = md(paste("Dados da PNADc ", year,".", quartile, sep = "" ))
          ) %>%
          sub_missing(
            columns = 1:ncol(tabela),
            missing_text = "Grand total")
      }

      if (export == FALSE) {
        return(tabela_final)
      }
      if (export == "df") {
        return(tabela)
      }
      if (export == "csv") {
        utils::write.csv2(tabela_final, file = paste(path, "/Tabela_pnadc_total_", year, "_", quartile,".csv", sep = ""))
        message(paste("Saved in directory: ", path, sep = ""))
      } else {
        gt::gtsave(tabela_final, filename = paste("Tabela_pnadc_total_", year, "_", quartile,".", export, sep = ""), path = path)
        message(paste("Saved in directory: ", path, sep = ""))
      }

      rm(list = c("tabela", "tabela_final", "grupo"))
      gc(reset = TRUE)
    }
    else {
      if (file.exists(fs::path_home(paste("Design","PNADc", year, quartile, sep = "_"))) == TRUE) {
        Design <- paste("Design","PNADc", year, quartile, sep = "_")
        load(fs::path_home(Design))
      } else {
        pnadc_download(year = year, quartile = quartile, path = path)

        Design <- paste("/Design","PNADc", year, quartile, sep = "_")
        load(paste(path, Design, sep = ""))
      }

      tabela <- survey::svyby(formula = variable, by = filter, design = design_PNADc, FUN = survey::svytotal, na.rm = TRUE, na.rm.by = TRUE, na.rm.all = TRUE)
      tabela <- as.data.frame(tabela)

      rm(design_PNADc)
      gc()

      grupo <- as.character(filter)
      grupo <- unlist(strsplit(grupo, split = " "))

      if (length(grupo) > 3) {
        tabela_final <- gt::gt(tabela, groupname_col = grupo[4]) %>%
          tab_header(
            title = md(paste(variable))
          ) %>%
          tab_options(
            table.align = "left",
            heading.background.color = "lightblue3",
            column_labels.background.color = "lightcyan",
            stub.background.color = "lightcyan",
            source_notes.background.color = "lightcyan"
          ) %>%
          tab_source_note(
            source_note = md(paste("Dados da PNADc ", year,".", quartile, sep = "" ))
          ) %>%
          sub_missing(
            columns = 1:ncol(tabela),
            missing_text = "Grand total")
      } else {
        tabela_final <- gt::gt(tabela) %>%
          tab_header(
            title = md(paste(variable))
          ) %>%
          tab_options(
            table.align = "left",
            heading.background.color = "lightblue3",
            column_labels.background.color = "lightcyan",
            stub.background.color = "lightcyan",
            source_notes.background.color = "lightcyan"
          ) %>%
          tab_source_note(
            source_note = md(paste("Dados da PNADc ", year,".", quartile, sep = "" ))
          ) %>%
          sub_missing(
            columns = 1:ncol(tabela),
            missing_text = "Grand total")
      }

      if (export == FALSE) {
        return(tabela_final)
      }
      if (export == "df") {
        return(tabela)
      }
      if (export == "csv") {
        utils::write.csv2(tabela_final, file = paste(path, "/Tabela_pnadc_total_", year, "_", quartile,".csv", sep = ""))
        message(paste("Saved in directory: ", path, sep = ""))
      } else {
        gt::gtsave(tabela_final, filename = paste("Tabela_pnadc_total_", year, "_", quartile,".", export, sep = ""), path = path)
        message(paste("Saved in directory: ", path, sep = ""))
      }

      rm(list = c("tabela", "tabela_final", "grupo"))
      gc(reset = TRUE)
    }
  }
}
