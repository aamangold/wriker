#' @title Wrike Tasks
#'
#' @description Pulls a list of all Wrike tasks based on specified folder
#' @param folder_name
#'
#' @import httr
#' @import dplyr
#' @import purrr
#'
#' @export
#'
#' @examples
#' wrike_tasks("My Folder Name")


wrike_tasks <- function(folder_name) {
    folder_id <- wriker::wrike_folder_id(folder_name)

    wriker::authenticate()

    url <- paste0("https://www.wrike.com/api/v3/folders/", folder_id, "/tasks")
    GET_request <- httr::GET(url, httr::add_headers(Authorization = paste("Bearer", v3_key, sep = " ")))

    tasks <- httr::content(GET_request)[[2]]

    task_extract <- purrr::map_df(tasks, magrittr::extract, c("id", "accountId", "title", "status", "importance",
                                                              "permalink", "updatedDate", "customStatusId")) %>%
                    dplyr::mutate(folder = folder_name)

    task_dates <- purrr::map_df(tasks, "dates")

    task_data <- dplyr::bind_cols(task_extract, task_dates)
    return(task_data)
}




#' @title Wrike Tasks by ID
#'
#' @description Pulls a list of Wrike task information by the Wrike task id
#' @param task_id Wrike task id
#' @param fields Defaults to all, you can select a specific field by name
#'
#' @import httr
#' @import dplyr
#' @import purrr
#'
#' @export
#'
#' @examples
#' wrike_task_data("IEABOGRQKQAN3QOA")
#' wrike_task_data("IEABOGRQKQAN3QOA", fields = "title")
#' wrike_task_data("IEABOGRQKQAN3QOA", fields = c("title", "status", "id"))
#'



wrike_task_data <- function(task_id, fields = NULL) {

    wriker::authenticate()

    url <- paste0("https://www.wrike.com/api/v3/tasks/", task_id)
    GET_request <- httr::GET(url, httr::add_headers(Authorization = paste("Bearer", v3_key, sep = " ")))

    tasks <- httr::content(GET_request)[[2]]

    task_extract <- purrr::map_df(tasks, magrittr::extract, c("id", "accountId", "title", "status", "importance",
                                                              "permalink", "updatedDate", "customStatusId"))

    task_dates <- purrr::map_df(tasks, "dates")
url
    task_data <- dplyr::bind_cols(task_extract, task_dates)

    if(!is.null(fields)) {
        print(task_data %>%
                  dplyr::select(dplyr::one_of(fields)))
    } else {
        print(task_data)
    }

}


