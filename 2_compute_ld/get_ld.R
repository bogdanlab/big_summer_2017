# import the necessary libraries
library("data.table")
library("plink2R")

# load in the reference genotype data
ref_file_name = "/u/project/pasaniuc/shihuwen/big_summer_data_tmp/1000G.EUR.1"
ref_file = read_plink(ref_file_name, impute="avg")

# parse out legend and the genotype data
ref_legend = ref_file$bim
colnames(ref_legend) = c("CHR", "ID", "CM", "POS", "REF", "ALT")
ref_genotype = ref_file$bed

# define a function to compute the ld matrix
get_ld <- function(legend, genotype, start_pos, end_pos) {

    # extract snps whose position is greater than or equal to start_pos and
    # less than end_pos
    genotype_region = genotype[, legend$POS>=start_pos & legend$POS<end_pos]

    # compute the correlation
    ld = cor(genotype_region)
    ld[is.nan(ld)] = 0.0

    return(ld)
}

# run the get_maf function on our data set
start_pos = 10583
end_pos = 1892607
ld = get_ld(ref_legend, ref_genotype, start_pos, end_pos)

# visualize the ld matrix
ld_img = apply(ld, 2, rev)
pdf("ld_plot.pdf")
image(t(ld_img),col=cm.colors(12))
dev.off()
