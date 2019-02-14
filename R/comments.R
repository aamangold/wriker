#' @title Get Wrike Comments from folder
#'
#' @description Pulls a list of comments associated with specified task. Last 7 days only.
#' @param folder_id Wrike folder id that you want to get comments from. Find ids using 'wrike_folders()'
#'
#' @import httr
#' @import dplyr
#' @import purrr
#' @import magrittr
#'
#' @export
#'
#' @examples
#' wrike_get_comments("My Folder ID")


wrike_get_comments <- function(folder_id) {
    wrikeR::authenticate()

    url <- paste0("https://www.wrike.com/api/v3/folders/", folder_id, "/comments")
    GETcoms <- httr::GET(url, httr::add_headers(Authorization = paste("Bearer", v3_key, sep = " ")))
    coms <- httr::content(GETcoms)
    comments <- purrr::map_df(coms$data, magrittr::extract)
    return(comments)
}


#' @title Create simple comment on Wrike task
#'
#' @description Pulls a list of comments associated with specified task. POST function allows for comment creation on specified task
#' @param taskId Id associated with the task you want to create a comment on (ex:IEABOGRQKQAN3QOA)
#' @param commentText short, single word comment
#' @keywords
#'
#' @import httr
#' @import dplyr
#' @import purrr
#' @import magrittr
#'
#' @export
#'
#' @examples
#' wrike_url_comment_post("My Task ID", "hello")
#' wrike_url_comment_post("IEABOGRQKQAN3QOA", "hello")


wrike_url_comment_post <- function(taskId, commentText) {
    wrikeR::authenticate()

    APIcoms <- paste0("https://www.wrike.com/api/v3/tasks/", taskId, "/comments?text=", commentText)
    POSTsimplecom <- httr::POST(APIcoms, httr::add_headers(Authorization = paste("Bearer", v3_key, sep = " ")))
}



#' @title Create comment on Wrike task
#'
#' @description Create a comment on a specified Wrike task
#' @param task_id Wrike task id associated with the task you want to create a comment on (ex:IEABOGRQKQAN3QOA)
#' @param comment_text Text of the comment you want added to Wrike
#' @keywords
#'
#' @import httr
#' @import dplyr
#' @import purrr
#' @import magrittr
#'
#' @export
#'
#' @examples
#' create_wrike_task_comment("My Task Id", "comment")
#' create_wrike_task_comment("IEABOGRQKQAN3QOA", "hello there")




create_wrike_task_comment <- function(task_id, comment_text) {

    wrikeR::authenticate()

    url <- paste0("https://www.wrike.com/api/v3/tasks/", task_id, "/comments")
    body <- list(text = comment_text)

    post_comment <- httr::POST(url, body = body, encode = "json",
                               httr::add_headers(Authorization = paste("Bearer", v3_key, sep = " ")))

}



#' @title Get comments on Wrike task
#'
#' @description Get dataframe of comments on a specified Wrike task
#' @param task_id Id associated with the task you want to create a comment on (ex:IEABOGRQKQAN3QOA)
#'
#' @import httr
#' @import dplyr
#' @import purrr
#' @import magrittr
#'
#' @export
#'
#' @examples
#' get_wrike_task_comment("My Task Id")
#' get_wrike_task_comment("IEABOGRQKQAN3QOA")



get_wrike_task_comment <- function(task_id) {

    wrikeR::authenticate()

    APIcoms <- paste0("https://www.wrike.com/api/v3/tasks/", task_id, "/comments")
    GETcoms <- httr::GET(APIcoms, httr::add_headers(Authorization = paste("Bearer", v3_key, sep = " ")))

    comments <- httr::content(GETcoms)[["data"]]

    comment_extract <- comments %>% purrr::map_df(magrittr::extract)

    return(comment_extract)

}


#' @title Get all comments in the past 7 days
#'
#' @description Get dataframe of comments associated with your Wrike account
#' @keywords
#'
#' @import httr
#' @import dplyr
#' @import purrr
#' @import magrittr
#'
#' @export
#'
#' @examples
#' get_wrike_comments()



get_wrike_comments <- function() {

    wrikeR::authenticate()

    url <- paste0("https://www.wrike.com/api/v3/accounts/", account_id, "/comments?plainText=true")
    GETcoms <- httr::GET(url, httr::add_headers(Authorization = paste("Bearer", v3_key, sep = " ")))
    comments <- httr::content(GETcoms)[["data"]]
    comment_extract <- comments %>% purrr::map_df(magrittr::extract)

    return(comment_extract)
}


