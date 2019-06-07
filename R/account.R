#' @title Wrike Account Information
#'
#' @description This function queries Wrike account information.
#' @return A tibble with the following account fields: id, name, dateFormat, rootFolderId, createdDate
#' @import httr
#' @import purrr
#' @import magrittr
#'
#'
#' @export
#' @examples
#' wrike_account_data()

wrike_account_data <- function() {

    wriker::authenticate()

    url <- "https://www.wrike.com/api/v4/account"
    get <- httr::GET(url,
                     httr::add_headers(Authorization = paste("Bearer", v4_key,
                                                             sep = " ")))

    account <- httr::content(get)[["data"]]

    account_extract <- purrr::map_df(account, magrittr::extract,
                  c("id", "name", "dateFormat", "rootFolderId", "createdDate"))

    return(account_extract)

}


#' @title Wrike Account ID
#'
#' @description This function pulls the organization's Wrike account ID for authentication.
#' @import httr
#' @import purrr
#' @import magrittr
#' @import dplyr
#'
#' @examples
#' wrike_account_id()

wrike_account_id <- function() {
    wrike_account_data() %>% pull("id")
}






