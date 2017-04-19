library(tidyr)
library(dplyr)
library(ggplot2)
library(gridExtra)

# Key takeaway: x axis label get melted into one column in the input data
setwd("/Users/Ruixuan/Documents/01infoVisual/hw/hw1/")

glmnet <- read.csv("results-glmnet-cross-table.csv")
gradient <- read.csv("results-gradient-boosting.csv")
pgboost <- read.csv("results-pgboost-cross-table.csv")

# one dataset for mederr, one dataset for rmse, one for mederr
mederr <- data.frame(index = glmnet[,c(1)], glmnet = glmnet[, c(3)], boosting = pgboost[, c(3)])
rmse <- data.frame(index = glmnet[,c(1)], glmnet = glmnet[, c(2)], boosting = pgboost[, c(2)])

# gather: wide to long data
# columns names becomes one variable --> label
# arg1-arg5: short dataset,level,value,column name1,columns name2 [-column1]
long_mederr <- gather(mederr, label, value, glmnet, boosting)
long_rmse <- gather(rmse, label, value, glmnet, boosting)

plot1 <- ggplot(data = long_mederr, aes(x=label, y=value)) + geom_boxplot() + ggtitle("MedErr") + theme(axis.title.x=element_blank(), 
                                                                                                        axis.title.y = element_blank(), 
                                                                                                        plot.title = element_text(hjust = 0.5))

plot2 <- ggplot(data = long_rmse, aes(x=label, y=value)) + geom_boxplot() + ggtitle("RMSE") + theme(axis.title.x=element_blank(), 
                                                                                                    axis.title.y = element_blank(), 
                                                                                                    plot.title = element_text(hjust = 0.5))

# This is useful when the two plots are not based on the same data
# http://stackoverflow.com/questions/1249548/side-by-side-plots-with-ggplot2
grid.arrange(plot1, plot2, ncol=2, top = "Comparing glmnet and gradient boosting")

