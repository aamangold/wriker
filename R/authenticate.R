#' @title Authenticate your machine with Wrike identifiers
#'
#' @description Loads Wrike authenticate keys from Sys.getenv as account_id and v3_key
#'
#' @export
#'
#' @examples
#' authenticate()
#'



authenticate <- function() {

    account_id <<- Sys.getenv('WRIKE_ACCOUNT_ID')
    if (identical(account_id, "")) {
        stop("Please set env var WRIKE_ACCOUNT_ID",
             call. = FALSE)
    }
    
    v3_key <<- Sys.getenv('WRIKE_V3_KEY')
    if (identical(v3_key, "")) {
        stop("Please set env var WRIKE_V3_KEY",
             call. = FALSE)
    }

}
