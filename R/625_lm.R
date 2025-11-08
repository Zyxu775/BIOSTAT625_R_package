#'Linear Regression Model
#'
#'This function fits a simple linear regression model to the provided data,
#'using basic matrix algebra. It returns coefficients, fitted values, residuals,
#'R-squared, adjusted R-squared, standard error, F-statistic, and degrees of freedom.
#'@param x A numeric matrix of predictor variables.
#'@param y A numeric vector of response variables.
#'
#'@return is a list summarizing the fitted model results.
#'
#'@examples
#' data(mtcars)
#' x <- as.matrix(mtcars[, c("wt", "hp", "cyl")])
#' y <- mtcars$mpg
#' results <- lm_625(x, y)
#' print(results)
#'
#'@export
#'

lm_625 <- function(x,y){
  if(!is.matrix(x)){
    stop("X should be a matrix of predictor variables")
  }
  if(!is.numeric(y) || !is.vector(y)){
    stop("Y should be a numeric vector of response variables")
  }

  if(nrow(x) != length(y)){
    stop("Number of rows in X must match length of Y")
  }

  if(!all(x[,1] == 1)){
    x <- cbind(1, x)  # Add intercept term
  }

  X <- as.matrix(x)
  Y <- as.numeric(y)
  n <- nrow(X)
  p <- ncol(X)

  XTX <- t(X) %*% X
  XTY <- t(X) %*% Y
  beta_hat <- solve(XTX,XTY)

  predicted_Y <- X %*% beta_hat
  residuals <- Y - predicted_Y
  residuals_summary <- summary(residuals)
  RSS <- sum(residuals^2)
  TSS <- sum((Y - mean(Y))^2)
  R_squared <- 1 - (RSS / TSS)
  adjusted_R_squared <- 1 - ((RSS / (n - p)) / (TSS / (n - 1)))
  sigma_squared <- RSS / (n - p)
  standard_error <- sqrt(sigma_squared)
  F_statistic <- ( (TSS - RSS) / (p - 1) ) / ( RSS / (n - p) )
  degrees_of_freedom <- c(p - 1, n - p)

  list(
    coefficients = as.vector(beta_hat),
    fitted.values = as.vector(predicted_Y),
    residuals = as.vector(residuals),
    residuals.summary = residuals_summary,
    r.squared = R_squared,
    adj.r.squared = adjusted_R_squared,
    sigma = standard_error,
    f.statistic = F_statistic,
    df = degrees_of_freedom,
    call = match.call()
  )
}
