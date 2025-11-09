# biostat625rpackage

[![R-CMD-check](https://github.com/zyxu775/BIOSTAT625_R_package/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/zyxu775/BIOSTAT625_R_package/actions)

This R package was developed as part of **BIOSTAT 625** at the **University of Michigan**.  
It demonstrates how to implement a **simple linear regression model** in both **base R** and **Rcpp**, with comprehensive testing, benchmarking, and documentation.

---

## Overview

The goal of **biostat625rpackage** is to provide optimized implementations of linear regression using matrix operations. The package includes:

- **`lm_625()`**: A pure R implementation using matrix algebra
- **`lm_625_withcpp()`**: An Rcpp-accelerated version for improved performance

Both functions are designed to produce results consistent with base R's `lm()` function.

## Key Features

- Efficient computation of regression coefficients using matrix algebra
- Two implementations: pure R and Rcpp-optimized
- Detailed output including:
  - Coefficients
  - Fitted values
  - Residuals and residual summary statistics
  - R-squared and adjusted R-squared
  - Standard error (sigma)
  - F-statistic
  - Degrees of freedom
- Validation against base R `lm()` function
- Performance benchmarking capabilities

---

## Installation

You can install the development version of biostat625rpackage from [GitHub](https://github.com/zyxu775/BIOSTAT625_R_package)
```r
# Install devtools if not already installed
install.packages("devtools")

# Install the package
devtools::install_github("zyxu775/BIOSTAT625_R_package")
```

---

## Example

Below is an example of how to use both functions with the built-in `mtcars` dataset:
```r
library(biostat625rpackage)
data(mtcars)

# Prepare data
x <- as.matrix(mtcars[, c("wt", "hp", "cyl")])
y <- mtcars$mpg

# Fit model using pure R implementation
result_r <- lm_625(x, y)
print(result_r)

# Fit model using Rcpp implementation
result_cpp <- lm_625_withcpp(x, y)
print(result_cpp)

# Compare with base R lm()
result_base <- lm(mpg ~ wt + hp + cyl, data = mtcars)
summary(result_base)
```

---

## Output

The Rcpp version leverages C++-based matrix operations and Cholesky decomposition to improve computational efficiency.

Both `lm_625()` and `lm_625_withcpp()` return a list with the following components:

- **`coefficients`**: The estimated regression coefficients (intercept and slopes)
- **`fitted.values`**: The predicted values based on the model
- **`residuals`**: The differences between observed and predicted values
- **`residuals.summary`**: Summary statistics of residuals (Min, 1Q, Median, 3Q, Max)
- **`r.squared`**: Proportion of variance explained by the model
- **`adj.r.squared`**: Adjusted R-squared accounting for the number of predictors
- **`sigma`**: Standard error of residuals
- **`f.statistic`**: F-test statistic for the overall model fit
- **`df`**: Degrees of freedom (regression, residuals)
- **`call`**: The function call

---

## Benchmarking Performance

Compare the computational efficiency of both implementations against base R:
```r
library(bench)

# Benchmark all three methods
benchmark_results <- bench::mark(
  lm_625 = lm_625(x, y),
  lm_625_withcpp = lm_625_withcpp(x, y),
  base_lm = lm(mpg ~ wt + hp + cyl, data = mtcars),
  iterations = 1000,
  check = FALSE
)

print(benchmark_results)
```

Expected findings:
- The Rcpp implementation typically offers performance improvements for larger datasets
- For small datasets like `mtcars`, differences may be minimal
- All implementations produce statistically identical results

---

## Testing

Unit tests are implemented using the **testthat** framework to ensure reproducibility and correctness.
The package includes comprehensive tests to ensure correctness:
```r
# Run all tests
devtools::test()
```

---

## Contributing

Contributions are welcome! You can create an issue or submit a pull request on the GitHub repository.

---

## License

This package is released under the MIT License.

---

## Acknowledgments

This package was created as part of the BIOSTAT 625 course at the University of Michigan School of Public Health. Special thanks to the course instructors and teaching team for their guidance.

