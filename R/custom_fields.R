#' @title Wrike Custom Field Use by Folder
#'
#' @description This function pulls a list of your task ids within a folder that have a specified custom field filled out
#' @param folder_id Wrike folder id. Use \code{\link{wrike_folders}} function to determine if needed.
#' @param custom_field_id Wrike custom field id. Use \code{\link{wrike_custom_field_url}} function to determin if needed.
#' @return A list of all Wrike task ids in a folder that have the specified custom field filled out
#' @import httr
#' @import purrr
#' @import magrittr
#' @import stringr
#' @import dplyr
#'
#' @export
#' @examples
#' wrike_custom_field_exists(folder_id = "IEAAAOH5I4AB7JFG", custom_field_id = "IEAAAOH5JUAAABQ5")


wrike_custom_field_exists <- function(folder_id, custom_field_id) {

    wrikeR::authenticate()

    url <- paste0('https://www.wrike.com/api/v3/folders/', folder_id, '/tasks?fields=["customFields"]')
    GETdata <- httr::GET(url, httr::add_headers(Authorization = paste("Bearer", v3_key, sep = " ")))

    dat <- httr::content(GETdata)
    dat2 <- dat[[2]]

    field_list <- dplyr::data_frame()
    for(i in seq_along(dat2)){
        tmp <- dplyr::bind_cols(fields = sum(stringr::str_detect(unlist(dat$data[[i]]$`customFields`),
                                                 custom_field_id)),
                         id = purrr::map_df(dat2[i], magrittr::extract, c("id")))
        field_list <- dplyr::bind_rows(field_list, tmp)
    }

    print(field_list %>% dplyr::filter(fields > 0 & nchar(id) > 4))
}




#' @title Wrike Custom Field Use by Task Id
#'
#' @description This function pulls a list of the custom field values & ids associated with specified task ids
#' @param task_id Wrike task id
#' @param custom_field_id Use \code{\link{wrike_custom_field_url}} function to find id if needed.
#'
#' @import httr
#' @import purrr
#' @import magrittr
#' @import stringr
#'
#' @export
#' @examples
#' wrike_custom_field_on_task(task_id = "IEABOGRQKQAN3QOA", custom_field_id = "IEAAAOH5JUAAABQ5")
#'

wrike_custom_field_on_task <- function(task_id, custom_field_id){
    wrikeR::authenticate()

    url <- paste0("https://www.wrike.com/api/v3/tasks/", task_id)
    GET <- httr::GET(url, httr::add_headers(Authorization = paste("Bearer", v3_key, sep = " ")))

    data <- httr::content(GET)
    data2 <- data[["data"]]

    custom_fields <- unlist(data$data[[1]]$`customFields`)
    custom_field_count <- sum(stringr::str_detect(custom_fields, custom_field_id))

    id_extract <- map_dfr(data2, magrittr::extract, c("id"))


    results <- data.frame(id = id_extract,
                          custom_field_count = custom_field_count)

    return(results)
}


#' @title Wrike Custom Field URL
#'
#' @description This function gives you the URL to access your account's custom fields
#'
#' @export
#' @examples
#' wrike_custom_field_url()
#'

wrike_custom_field_url <- function() {

    wrikeR::authenticate()

    print(paste0("https://www.wrike.com/api/v3/accounts/", account_id, "/customfields"))

}



#' @title Wrike Custom Field Update
#'
#' @description This function populates a custom field from specified task id
#' @param task_id Wrike task id
#' @param custom_field_id Use \code{\link{wrike_custom_field_url}} function to find id if needed.
#' @param custom_field_value What you want populated
#'
#' @import httr
#' @import purrr
#' @import magrittr
#' @import stringr
#'
#' @export
#' @examples
#' wrike_custom_field_update(task_id = "IEABOGRQKQAN3QOA", custom_field_id = "IEAAAOH5JUAAABQ5", custom_field_value = "myvalue") <-- UPDATE for gh
#'

wrike_custom_field_update <- function(task_id, custom_field_id, custom_field_value) {
    wrikeR::authenticate()

    tmp <- jsonlite::toJSON(data.frame(id = custom_field_id, value = custom_field_value))
    tmp2 <- list(customFields = tmp)

    url <- paste0("https://www.wrike.com/api/v3/tasks/", task_id)
    body <- tmp2

    httr::PUT(url, body = body, encode = "json",
              add_headers(Authorization = paste("Bearer", v3_key, sep = " ")))

}



