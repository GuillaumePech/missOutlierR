
#' Detect Outliers Using the MISS Method
#'
#' Identifies outliers using the MISS method, a weighted composite of three
#' classical outlier detection approaches: Median Absolute Deviation (MAD),
#' Interquartile Range (IQR), and Standard Deviation (SD).
#'
#' @details
#' The MISS threshold is computed as a weighted combination:
#'
#' \deqn{MISS = 0.878 \times MAD + 0.012 \times IQR + 0.11 \times SD}
#'
#' Where:
#' \itemize{
#'   \item MAD bounds: \code{median ± 1.5 * MAD}
#'   \item IQR bounds: \code{Q25/Q75 ± 2 * IQR}
#'   \item SD bounds: \code{mean ± 5 * SD}
#' }
#'
#' Values outside the combined MISS bounds are flagged as outliers.
#'
#' @param data A numeric vector.
#' @param drop Logical. If \code{TRUE}, removes outliers from the result.
#'   If \code{FALSE} (default), replaces outliers with \code{NA}.
#' @param na.rm Logical. If \code{TRUE}, removes \code{NA} values before
#'   computing thresholds. Default is \code{FALSE}.
#' @param silent Logical. If \code{TRUE}, suppresses the message reporting
#'   the number of detected outliers. Default is \code{FALSE}.
#'
#' @return A numeric vector with outliers either removed or replaced by \code{NA},
#'   depending on the \code{drop} argument.
#'
#' @examples
#' # Basic usage
#' x <- c(rnorm(50), 20, 100)
#' detect_outlier_miss(x)
#'
#' # Drop outliers instead of replacing with NA
#' detect_outlier_miss(x, drop = TRUE)
#'
#' # Handle data with existing NAs
#' x_na <- c(rnorm(50), NA, 100)
#' detect_outlier_miss(x_na, na.rm = TRUE)
#'
#' # Silent mode
#' detect_outlier_miss(x, silent = TRUE)
#'
#' #' @references
#' Pech, G., Vaccaro, N., Caspar, E. A., Amerio, P., Cleeremans, A., Leys, C.,
#' & Ley, C. (2026). How not to MISS an outlier: comparing three classic
#' univariate methods and introducing a new one, the MAD-IQR-SD Simultaneous
#' (MISS). \emph{PsyArXiv}.
#' \doi{10.31234/osf.io/2r9yw_v2}
#' @export


detect_outlier_miss <- function(data, drop = FALSE, na.rm = FALSE, silent = FALSE) {
  #force data to numeric if not already
  data <- as.numeric(data)
  #error if data is more than one dimension
  if (length(dim(data)) > 1) {
    stop("Data must be one-dimensional")
  }
  
  # Outlier detection using Median Absolute Deviation (MAD)
  outlier_upper_mad <- median(data, na.rm = na.rm) + (1.5 * mad(data, na.rm = na.rm))
  outlier_lower_mad <- median(data, na.rm = na.rm) - (1.5 * mad(data, na.rm = na.rm))

  # Outlier detection using Interquartile Range (IQR)
  outlier_upper_iqr <- quantile(data, .75, na.rm = na.rm) + (2 * IQR(data, na.rm = na.rm))
  outlier_lower_iqr <- quantile(data, .25, na.rm = na.rm) - (2 * IQR(data, na.rm = na.rm))

  # Outlier detection using Standard Deviation (SD)
  outlier_upper_sd <- mean(data, na.rm = na.rm) + (5 * sd(data, na.rm = na.rm))
  outlier_lower_sd <- mean(data, na.rm = na.rm) - (5 * sd(data, na.rm = na.rm))
  # Combine all outlier thresholds into the MISS
  outlier_upper_MISS <- 0.878 * outlier_upper_mad + 0.012 * outlier_upper_iqr + 0.11 * outlier_upper_sd 
  outlier_lower_MISS <- 0.878 * outlier_lower_mad + 0.012 * outlier_lower_iqr + 0.11 * outlier_lower_sd


  outlier_idx  <- which(data <= outlier_lower_MISS | data >= outlier_upper_MISS)
  # percentage outliers
  pct_outliers <- length(outlier_idx) / length(data) * 100

  if (!silent) {
    message(paste0("Detected ", length(outlier_idx), " outliers (", round(pct_outliers, 2), "% of data) using MISS method."))
  }

  if (drop) {
    data <- data[-outlier_idx]
  } else {
    data[outlier_idx] <- NA
  }

  return(data)
}

