#' @title Wrike Workflows
#'
#' @description Pulls a list of all Wrike workflow labels + adds a progress tracker
#'
#' @import httr
#' @import dplyr
#' @import purrr
#'
#' @export
#'
#' @examples
#' wrike_workflows()

wrike_workflows <- function() {

    wriker::authenticate()
    
    url <- paste0("https://www.wrike.com/api/v4/workflows")
    #url <- paste0("https://www.wrike.com/api/v3/accounts/", account_id, "/workflows")
    GETworkflows <- httr::GET(url, httr::add_headers(Authorization = paste("Bearer", v4_key, sep = " ")))
    work <- httr::content(GETworkflows)[["data"]]
    work2 <- purrr::map(work, "customStatuses", "id")

    workflows <- tibble::tibble()

    for (i in seq_along(work2)) {
        dat <- bind_rows(work2[[i]]) %>%
            filter(hidden == "FALSE") %>%
            mutate(stage = row_number(),
                   active_stages = ifelse(group == "Active", row_number(), 0),
                   progress = ifelse(group == "Active", paste0("Stage ", stage, " of ", max(active_stages)+1),
                                     group)) %>%
            select(-c(3, 4, 5, 7)) %>%
            rename(missionStatus = name, customStatusId = id)


        workflows <- bind_rows(workflows, dat)

    }

    return(workflows)
}




