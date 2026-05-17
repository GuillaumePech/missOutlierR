#' Detect Outliers Using the MISS Method
#'
#' Identifies outliers via a weighted combination of MAD, IQR, and SD
#' thresholds (0.878 * MAD + 0.012 * IQR + 0.11 * SD).
#'
#' @param data A numeric vector.
#' @param drop If TRUE, removes outliers; if FALSE, replaces with NA (default FALSE).
#' @param na.rm If TRUE, remove NA values before computation (default FALSE).
#' @param silent If TRUE, suppress messages (default FALSE).
#' @return A numeric vector with outliers removed or replaced by NA.
#' @export
#' @examples
#' x <- c(rnorm(50), 20, 100)
#' detect_outlier_miss(x)
#' detect_outlier_miss(x, drop = TRUE)

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

