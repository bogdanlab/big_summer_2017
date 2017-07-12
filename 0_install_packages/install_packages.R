# install data.table if not already installed
if(!require("data.table")) {
    install.packages("data.table", dep=TRUE)
}

# install svd if not already installed
if(!require("svd")) {
    install.packages("svd", dep=TRUE)
}

# install RcppEigen if not already installed
if(!require("RcppEigen")) {
    install.packages("RcppEigen", dep=TRUE)
}

# install plink2R if not already installed
if(!require("plink2R")) {
    install.packages("/u/project/pasaniuc/shihuwen/software/plink2R-master/plink2R", dep=TRUE)
}
