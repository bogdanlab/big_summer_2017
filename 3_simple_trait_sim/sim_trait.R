# simulate a nindv * nsnp genotype matrix
sim_geno = function(nindv, nsnp) {

    # first, generate nsnp allele frequencies at random from 0 to 1
    af = runif(nsnp, 0.0, 1.0)

    # initialize the genotype matrix
    geno = matrix(0, nindv, nsnp)

    # sample snp from binomial distribution
    for(i in 1:nsnp) {
        geno[,i] = rbinom(nindv, 2, af[i])
    }

    # return the simulated allele frequency and genotype matrix
    return(list("af"=af, "geno"=geno))
}

# first simulate a genotype matrix at 100 SNPs for 10,000 individuals
nindv = 10000
nsnp = 500
sim = sim_geno(nindv, nsnp)
sim_af = sim$af
X = sim$geno

# then simulate trait based on the model Y = X * beta + eps
sim_trait = function(X, hsq) {

    # get the dimension
    nindv = nrow(X)
    nsnp = ncol(X)

    # first standardize X so that each column have mean 0 and sd 1
    X = scale(X)

    # first draw the beta
    beta = rnorm(nsnp, mean=0.0, sd=sqrt(hsq/nsnp))

    # simulate the genetic component of the trait
    Xbeta = X %*% beta

    # add environmental effect of the trait
    eps = rnorm(nindv, mean=0.0, sd=sqrt(1.0-hsq))

    # combine genetic component and environmental compoenent
    Y = Xbeta + eps

    return(Y)
}

# simulate the trait at different heritability
pdf("zscore_dist.pdf")
all_hsq = c(0.1, 0.2, 0.3, 0.4, 0.5)
for(hsq in all_hsq) {

    # simulate trait a a specific heritability
    Y = sim_trait(X, hsq)

    # perform a simple GWAS
    # first standardize the data
    Y = scale(Y)
    X = scale(X)

    # iterate through each SNP
    nsnp = ncol(X)
    zscores = rep(0, nsnp)
    for(i in 1:nsnp) {
        fit = lm(Y ~ X[,i])
        beta_hat = coef(summary(fit))[2,1]
        beta_hat_se = coef(summary(fit))[2,2]
        zscores[i] = beta_hat / beta_hat_se
    }
    hist(zscores, xlim=c(-15, 15))
}
dev.off()
