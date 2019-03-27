library(DESeq2) # Main package
library(biomaRt) # Map gene IDs to gene names
library(stringi) # Some string operations
library(vsn) # meanSdPlot
library(IHW) # Independent hypothesis weighting
library(pheatmap) # Pretty heatmaps

# Speed things up
register(MulticoreParam())


# Raw count data
count_data_path_directory = "/bfg/data/courses/deNBI2019"
# Please change directory where you download it
table_counts <- read.delim(
  file = paste(count_data_path_directory,"GSE121843_all_counts.txt",sep="/"),
  sep = "\t",
  as.is = TRUE
)

# Create count matrix
matrix_counts <- data.matrix(table_counts[, -1])
rownames(matrix_counts) <- table_counts$gene_id

# Create coldata
table_samples <- as.data.frame(
  stri_split(
    str = colnames(matrix_counts),
    fixed = "_",
    simplify = TRUE
  )
)

colnames(table_samples) <- c("Treatment", "Replicate")
rownames(table_samples) <- colnames(matrix_counts)

table_samples$Treatment <- relevel(factor(table_samples$Treatment), "dmso")

# Create data object
dds <- DESeqDataSetFromMatrix(
  countData = matrix_counts,
  colData = table_samples,
  design = ~Treatment
)

# Filter low expression features
dds <- dds[rowSums(counts(dds)) > 5, ]

# Filter out extra annotation (not genes)
tail(rownames(dds))

dds <- dds[stri_detect(rownames(dds), fixed = "ENSG"), ]

tail(rownames(dds))

# Remove version info from Ensembl gene IDs
gene_ids_all <- unlist(
  stri_split(
    str = rownames(dds),
    regex = "\\.\\d*", # pattern is dot (.) followed by some number
    omit_empty = TRUE
  )
)

# Map Ensembl gene IDs to gene names
mart <- useMart(
  biomart = "ensembl",
  dataset = "hsapiens_gene_ensembl",
  verbose = TRUE
)

annotations <- getBM(
  attributes = c("ensembl_gene_id", "external_gene_name", "gene_biotype"),
  filters = "ensembl_gene_id",
  values = gene_ids_all,
  mart = mart
)

# Fix non-matching gene IDs using Ensemble gene IDs
gene_ids_matched <- annotations$ensembl_gene_id
gene_names_matched <- annotations$external_gene_name

gene_names <- gene_names_matched[match(gene_ids_all, gene_ids_matched)]

table(is.na(gene_names))

nonmatching_genes <- which(is.na(gene_names))
gene_names[nonmatching_genes] <- gene_ids_all[nonmatching_genes]

table(is.na(gene_names))

rownames(dds) <- gene_names

# Analyze!
dds <- DESeq(dds, parallel = TRUE)

# QC: Look at dispersion estimates
plotDispEsts(dds)

# Compare regularized log transformation vs simple log transformation
dds_rlog <- rlog(dds)
dds_log <- normTransform(dds)

matrix_counts_rlog <- assay(dds_rlog)
matrix_counts_log <- assay(dds_log)

meanSdPlot(matrix_counts_log)
meanSdPlot(matrix_counts_rlog)

# Look at PCA
plotPCA(dds_log, intgroup = "Treatment")
plotPCA(dds_rlog, intgroup = "Treatment")

# Look at correlation between samples
matrix_correlation_log <- cor(matrix_counts_log)
pheatmap(
  matrix_correlation_log,
  cutree_rows = 2,
  cutree_cols = 2,
  annotation_col = table_samples,
  main = "Log transformation"
)

matrix_correlation_rlog <- cor(matrix_counts_rlog)
pheatmap(
  matrix_correlation_rlog,
  cutree_rows = 2,
  cutree_cols = 2,
  annotation_col = table_samples,
  main = "Regularized log transformation"
)

# Calculate upregulated genes in thz500 and actinomycin150
resultsNames(dds)

lfc_threshold <- log2(1.5)
lfc_lines <- c(-lfc_threshold, lfc_threshold)
p_value_cutoff <- 0.05

results_thz <- results(
  dds,
  name = "Treatment_thz500_vs_dmso",
  alpha = p_value_cutoff,
  lfcThreshold = lfc_threshold,
  filterFun = ihw, # from IHW
  parallel = TRUE
)

results_actinomycin <- results(
  dds,
  name = "Treatment_actinomycin150_vs_dmso",
  alpha = p_value_cutoff,
  lfcThreshold = lfc_threshold,
  filterFun = ihw, # from IHW
  parallel = TRUE
)

summary(results_thz)
summary(results_actinomycin)

plotMA(results_thz, ylim = c(-10, 10), alpha = 0.05, main = "THZ")
abline(h = lfc_lines, col = "turquoise", lwd = 2)

plotMA(results_actinomycin, ylim = c(-10, 10), alpha = 0.05, main = "Actinomycin")
abline(h = lfc_lines, col = "turquoise", lwd = 2)

# Demonstrate log fold change shrinkage
results_thz_lfcs <- lfcShrink(
  dds,
  res = results_thz,
  coef = "Treatment_thz500_vs_dmso", # note the difference name -> coef
  lfcThreshold = lfc_threshold,
  type = "apeglm",
  parallel = TRUE
)

results_actinomycin_lfcs <- lfcShrink(
  dds,
  res = results_actinomycin,
  coef = "Treatment_actinomycin150_vs_dmso", # note the difference name -> coef
  lfcThreshold = lfc_threshold,
  type = "apeglm",
  parallel = TRUE
)

summary(results_thz_lfcs)
summary(results_actinomycin_lfcs)

par(mfrow = c(2, 2))

plotMA(results_thz, ylim = c(-10, 11), alpha = 0.05, main = "THZ, w/o LFC shrinkage")
abline(h = lfc_lines, col = "turquoise", lwd = 1)

plotMA(results_actinomycin, ylim = c(-10, 11), alpha = 0.05, main = "Actinomycin, w/o LFC shrinkage")
abline(h = lfc_lines, col = "turquoise", lwd = 1)

plotMA(results_thz_lfcs, ylim = c(-10, 11), main = "THZ, w/ LFC shrinkage")
abline(h = lfc_lines, col = "turquoise", lwd = 1)

plotMA(results_actinomycin_lfcs, ylim = c(-10, 11), main = "Actinomycin, w/ LFC shrinkage")
abline(h = lfc_lines, col = "turquoise", lwd = 1)

par(mfrow = c(1, 1))

# Visualize an interesting gene
TBXT_thz <- results_thz_lfcs["TBXT", 1:2]
TBXT_actinomycin <- results_actinomycin_lfcs["TBXT", 1:2]

plotMA(results_thz_lfcs, ylim = c(-10, 10), main = "THZ")
abline(h = lfc_lines, col = "turquoise", lwd = 2)
points(x = TBXT_thz$baseMean, y = TBXT_thz$log2FoldChange, pch = 16, col = "blue")
text(x = TBXT_thz$baseMean + 50000, y = TBXT_thz$log2FoldChange, "TBXT")

plotMA(results_actinomycin_lfcs, ylim = c(-10, 10), main = "Actinomycin")
abline(h = lfc_lines, col = "turquoise", lwd = 2)
points(x = TBXT_actinomycin$baseMean, y = TBXT_actinomycin$log2FoldChange, pch = 16, col = "blue")
text(x = TBXT_actinomycin$baseMean + 50000, y = TBXT_actinomycin$log2FoldChange, "TBXT")

plotCounts(dds, gene = "TBXT", intgroup = "Treatment", normalized = TRUE, pch = 16)
