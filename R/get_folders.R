#' @title Wrike Folders
#'
#' @description This function pulls a list of your Wrike folder names + ids. Ids will be used in task functions
#'
#' @import httr
#' @import purrr
#' @import magrittr
#'
#' @export
#'
#' @examples
#' wrike_folders()
#'

wrike_folders <- function() {

    wriker::authenticate()

    url <- paste0("https://www.wrike.com/api/v3/accounts/", account_id, "/folders")
    GETfolders <- httr::GET(url, httr::add_headers(Authorization = paste("Bearer", v3_key, sep = " ")))
    fold_content <- httr::content(GETfolders)[[2]]
    folders <- purrr::map_df(fold_content, magrittr::extract, c("id", "title"))
    return(folders)
}
