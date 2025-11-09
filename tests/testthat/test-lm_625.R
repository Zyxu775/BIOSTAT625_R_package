library(testthat)
library(biostat625rpackage)

test_that("lm_625 produces correct lm results", {
  data(mtcars)
  x <- as.matrix(mtcars[, c("wt", "hp", "cyl")])
  y <- mtcars$mpg

  test_res <- lm_625(x, y)
  true_res <- lm(mpg ~ wt + hp + cyl, data = mtcars)

  #compare coefficients
  expect_true(
    all.equal(
      as.numeric(test_res$coefficients),
      as.numeric(coef(true_res)),
      tolerance = 1e-6
    )
  )
})
