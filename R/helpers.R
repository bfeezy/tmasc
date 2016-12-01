#' Create URL from a unique identifier
#'
#' To avoid repetition, the raw data frames don't contain reports' URLs. This
#' function constructs a URL given an Erowid or Dreamjournal identifier.
#'
#' @param x Unique identifier (e.g. ID column from \code{erowid})
#' @param user Dreamjournal username
#' @param type "erowid" or "dreamjournal"
#'
#' @return A character string containing the full URL.
#'
#' @author Matti Vuorre \email{mv2521@columbia.edu}
#'
#' @examples
#' # To obtain an Erowid URL
#' create_url(erowid$id[1])
#' # To obtain a dreamjournal URL
#' create_url(dreamjournal$id[1], dreamjournal$user[1])
#'
#' @export
create_url <- function(x, user = NULL, type = NULL) {
    # Create URL given an identifier and type
    url <- NA_character_
    erowid <- "https://www.erowid.org/experiences/exp.php?ID="
    dreamjournal <- "http://www.dreamjournal.net/journal/dream/dream_id/"
    type <- ifelse(is.null(user), "erowid", "dreamjournal")
    url <- ifelse(type == "erowid",
                  paste0(erowid, x),
                  paste0(dreamjournal, x, "/username/", user))
    return(url)
}
