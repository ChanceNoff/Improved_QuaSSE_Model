lambda <- function(x) sigmoid.x(x, 0.1, 0.2,  0, 2.5)
mu <- function(x) constant.x(x, 0.03)
char <- make.brownian.with.drift(0, 0.025) ## this is where I think I add elevation data

namesforpstart <- function(x, y){
  names(x) <- argnames(y)
  return(x)
}

loopthroughrelationships <- function(x){ 
  result <-rep(NA, length(x))
    for (i in seq_along(x)) {
    split_result <- strsplit(x[i], "_")[[1]]
    result[i] <- paste0(split_result[2:length(split_result)], collapse =  "_")
  }
return(result)
} 