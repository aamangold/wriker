#' @title Wrike Folders
#'
#' @description This function pulls a list of your Wrike folder names + ids. Ids will be used in task functions
#'
#' @export
#'
#' @examples
#' wrike_folders()
#'

wrike_folders <- function() {

    wriker::authenticate()

    url <- paste0("https://www.wrike.com/api/v4/folders")
    #url <- paste0("https://www.wrike.com/api/v3/accounts/", account_id, "/folders")
    GETfolders <- httr::GET(url, httr::add_headers(Authorization = paste("Bearer", v4_key, sep = " ")))
    fold_content <- httr::content(GETfolders)[[2]]
    folders <- purrr::map_df(fold_content, magrittr::extract, c("id", "title"))
    return(folders)
}


#' @title Wrike Folders IDs
#'
#' @description This function grabs the folder id when given the folder name. 
#'
#' @export
#'
#' @examples
#' wrike_folder_id("My Folder Name")
#'

wrike_folder_id <- function(folder_name) {
    
    folder_id <- wrike_folders() %>% 
        dplyr::filter(title == folder_name) %>% 
        dplyr::pull(id)
    
    return(folder_id)
}




#' Wrike Folder Tree
#'
#' @description Pulls list of all child folders and folder ids from parent folder identified
#' @param folder_name Name of root folder to pull child ids from
#'
#' @export
#'
#' @examples
#' wrike_folder_tree("My Folder Name")
 

wrike_folder_tree <- function(folder_name) {
    wriker::authenticate()
    
    folder_id <- wriker::wrike_folder_id(folder_name)
    
    url <- paste0("https://www.wrike.com/api/v4/folders/", folder_id, "/folders")
    GETfolders <- httr::GET(url, httr::add_headers(Authorization = paste("Bearer", v4_key, sep = " ")))
    fold_content <- httr::content(GETfolders)[[2]]
    folders <- purrr::map_df(fold_content, magrittr::extract, c("id", "title"))
    return(folders)
    
    
}

