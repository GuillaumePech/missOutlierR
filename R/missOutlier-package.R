#' missOutlier: Outlier Detection Using the MISS Method
#'
#' The missOutlier package provides the MISS (MAD-IQR-SD-Synthesis) method
#' for robust outlier detection in univariate numeric data. It combines three
#' classical approaches with empirically derived weights to produce a single
#' composite threshold.
#'
#' @details
#' The MISS method computes upper and lower outlier bounds as a weighted
#' combination of three well-established techniques:
#'
#' \itemize{
#'   \item \strong{MAD} (Median Absolute Deviation): \code{median ± 1.5 * MAD}
#'     — robust to extreme values, weight = 0.878
#'   \item \strong{IQR} (Interquartile Range): \code{Q25/Q75 ± 2 * IQR}
#'     — distribution-free, weight = 0.012
#'   \item \strong{SD} (Standard Deviation): \code{mean ± 5 * SD}
#'     — sensitive to tails, weight = 0.11
#' }
#'
#' The composite threshold is:
#'
#' \deqn{MISS = 0.878 \times MAD + 0.012 \times IQR + 0.11 \times SD}
#'
#' This weighting scheme prioritises the robustness of MAD while retaining
#' sensitivity to distributional shape through the IQR and SD components.
#'
#' @section Main function:
#' \describe{
#'   \item{\code{\link{detect_outlier_miss}}}{Detect and handle outliers in a
#'     numeric vector using the MISS method. Outliers can be replaced with
#'     \code{NA} or removed entirely.}
#' }
#'
#' @section Getting started:
#' \preformatted{
#' library(missOutlier)
#'
#' x <- c(rnorm(100), 50, -40)
#' x_clean <- detect_outlier_miss(x)
#'
#' # Drop outliers instead of replacing with NA
#' x_dropped <- detect_outlier_miss(x, drop = TRUE)
#' }
#'
#' @author Guillaume Pech
#'
#' @references
#' Pech, G., Vaccaro, N., Caspar, E. A., Amerio, P., Cleeremans, A., Leys, C.,
#' & Ley, C. (2026). How not to MISS an outlier: comparing three classic
#' univariate methods and introducing a new one, the MAD-IQR-SD Simultaneous
#' (MISS). \emph{PsyArXiv}.
#' \doi{10.31234/osf.io/2r9yw_v2}
#'
#' @docType package
#' @name missOutlier-package
NULL
