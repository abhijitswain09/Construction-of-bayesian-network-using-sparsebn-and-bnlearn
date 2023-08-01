# Read the data from the file "filtered_rpkm.txt" into a data frame
mydata <- read.table("filtered_rpkm.txt", header = TRUE, sep = "\t")

# Subset the data to select specific rows and columns
mydata <- mydata[c(7, 8, 11, 12, 15, 16), 1:2000]

# Get the column names of the subsetted data
colnames <- colnames(mydata)

# Convert the subsetted data to numeric matrix
mydata <- as.matrix(mydata)

# Discretize the numeric data using the 'cut()' function
discret.data <- lapply(1:ncol(mydata), function(i) {
  cut(mydata[, i], breaks = 3, labels = FALSE)
})

# Convert the discretized data to a data frame
discret.data <- as.data.frame(discret.data)

# Assign the original column names to the discretized data
colnames(discret.data) <- colnames
mydata_white <- read.table("white_list_TF", header = FALSE, sep = "\t")
whitelist <- as.data.frame(mydata_white, stringsAsFactors = FALSE)
mydata_df = discret.data
rownames(mydata_df) = rownames(mydata)
unknown_nodes <- setdiff(whitelist$V1, colnames(mydata_df))

whitelist <- whitelist[!(whitelist$V1 %in% unknown_nodes) & !(whitelist$V2 %in% unknown_nodes), ]

network <- empty.graph(names(mydata_df))

n_cores <- 10
cl <- makeCluster(n_cores)
registerDoParallel(cl)
 
learn_structure <- function(data) {
  pc.stable(data, whitelist = whitelist)
}

networks <- foreach(data = split(mydata_df, 1:nrow(mydata_df)), .packages = "bnlearn") %dopar% {
  learn_structure(data)
}

# Stop the parallel backend
stopCluster(cl)

