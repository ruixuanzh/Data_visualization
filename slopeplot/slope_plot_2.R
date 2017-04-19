library(ggplot2)
library(scales)
library(plyr)
df <- read.csv("cancer_survival_rate.csv")
df <- df[, c(1,2,3,5)]
colnames(df) <- c("Cancer", "5year", "10year", "20year")


nu <- c(df$`5year`, df$`10year`, df$`20year`)
nu_rank <- rank(nu)
tmp <- data.frame('5year' =nu_rank[0:24], '10year' =nu_rank[25:48], '20year'=nu_rank[49:72])
colnames(tmp) <- c("5year_Position", "10year_Position", "20year_Position")

df<- cbind(df, tmp)
# define the starting point and end point of geom_segment line
x1 <-2 + 0.1
x11 <- 3.5 - 0.1
x2 <- x11+ 0.1
x22 <- 5.3

p<-ggplot(df) + geom_segment(aes(x=x1,xend=x11, y=df$`5year_Position`,yend=df$`10year_Position`), colour = "grey", size=.75)
p<-p + geom_segment(aes(x=x2, xend=x22, y=df$`10year_Position`,yend=df$`20year_Position`), colour = "grey", size=.75)
p


p<-p + theme(panel.background = element_blank())
p<-p + theme(panel.grid=element_blank())
p<-p + theme(axis.ticks=element_blank())
p<-p + theme(axis.text=element_blank())
p<-p + theme(panel.border=element_blank())

p<-p + xlab("") + ylab("")

p<-p + xlim(0, x22 + 1)
p<-p + ylim(0, 1.05*max(nu_rank))

label1 <- paste(cancer, df$`5year`, sep = "    ")
p <- p + geom_text(label=df$`5year`, y= df$`5year_Position`, x=rep.int(x1-0.1, dim(df)[1]), size=3, hjust=-0.1, check_overlap = FALSE)
p<-p + geom_text(label=df$`10year`, y=df$`10year_Position`, x=rep.int(x2 - 0.1, dim(df)[1]), size=3, hjust=-0.1, check_overlap = FALSE)
p<-p + geom_text(label=df$`20year`, y=df$`20year_Position`, x=rep.int(x22, dim(df)[1]), size=3, hjust=-0.1, check_overlap = FALSE)
p <- p + geom_text(label=df$Cancer, y=df$`5year_Position`, x=rep.int(x1 - 1, dim(df)[1]), size=3, vjust="center", check_overlap = FALSE)

p<-p + geom_text(label="5 years", x=x1 - 0.1,     y= (1.05*(max(year5, year10, year20))))
p<-p + geom_text(label="10 years", x=x2      ,    y= (1.05*(max(year5, year10, year20))))
p<-p + geom_text(label="20 years", x=x22 - 0.1,   y= (1.05*(max(year5, year10, year20))))
p <- p + ggtitle("Cancer Survival Rates")
p <- p + theme(plot.title = element_text(hjust = 0.5))
p <- p + theme(panel.border = element_rect(colour = "black", fill = NA))
p
