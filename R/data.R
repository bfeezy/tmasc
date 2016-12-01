#' Erowid Experience Reports
#'
#' @description Tidy data frame ready for text analysis.
#' \url{https://www.erowid.org/experiences/exp_front.shtml}).
#'
#' @docType data
#'
#' @usage head(erowid)  # Print first 6 rows
#'
#' @format A data frame (tibble) with 24788 rows and 14 variables:
#' \describe{
#'   \item{id}{Report ID on Erowid database}
#'   \item{title}{Title of the report}
#'   \item{author}{Name or pseudonym of author}
#'   \item{gender}{Author's gender}
#'   \item{age}{Age of author at time of experience}
#'   \item{kg}{weight of author in kg}
#'   \item{year}{Year when experience occurred}
#'   \item{published}{When report was published on Erowid}
#'   \item{rating}{Categorical rating of report quality}
#'   \item{views}{Number of views}
#'   \item{substance}{The (list of) substances reported}
#'   \item{text}{Report text}
#'   \item{erowid_warning}{Logical: Did report contain Erowid warning}
#'   \item{dosechart}{List-column: Extra info on substance and dose}
#' }
#'
#' @source \url{https://www.erowid.org/experiences/exp_front.shtml}
"erowid"

#' Dreamjournal Dream Reports
#'
#' @description Tidy data frame ready for text analysis.
#' \url{http://www.dreamjournal.net/}).
#'
#' @docType data
#'
#' @usage head(dreamjournal)  # Print first 6 rows
#'
#' @format A data frame (tibble) with 131661 rows and 15 variables:
#' \describe{
#'   \item{id}{Report ID}
#'   \item{dream}{Name of the dream, or title}
#'   \item{user}{Author's username}
#'   \item{date}{Date when report was logged}
#'   \item{rating}{Rating}
#'   \item{cohesion}{Cohesion of dream}
#'   \item{lucidity}{Rating of the dream's lucidity}
#'   \item{views}{Number of views}
#'   \item{themes}{List-column}
#'   \item{settings}{List-column}
#'   \item{characters}{List-column}
#'   \item{emotions}{List-column}
#'   \item{activities}{List-column}
#'   \item{keywords}{List-column}
#'   \item{text}{Text body of the dream report}
#' }
#'
#' @source \url{https://www.erowid.org/experiences/exp_front.shtml}
"dreamjournal"

