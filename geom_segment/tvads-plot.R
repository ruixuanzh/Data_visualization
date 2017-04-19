library(ggplot2)
library(gridExtra)
library(reshape2)

# creating a vector of time from 8am to 9am
d <- read.csv("fake-tvads-data.csv")
d$t <- strptime(as.character(d$t), '%Y-%m-%d %H:%M:%S')

# Top Plot Data da 720 observations
da <- subset(d, type=="audience")
da <- droplevels(da) # Removes unneeded types or categories

# Bottom Plot Data d 1440
d <- subset(d, type %in% c("tune_in", "tune_out"))
d <- droplevels(d)

# dataset for pink points 
events <- (60/5) * c(10, 20, 25, 35, 40, 47, 53)
red <- da[events,]
xinter <- red$t


# http://docs.ggplot2.org/dev/vignettes/themes.html
# http://colorbrewer2.org/#type=qualitative&scheme=Set1&n=4
# http://sape.inf.usi.ch/quick-reference/ggplot2/colour

### bottom

theme2 <- theme(
  axis.text = element_text(size = 10),
	axis.text.y=element_blank(),
	axis.title=element_blank(),
	axis.ticks.y=element_blank(),
        legend.background = element_rect(fill = "grey90", color="grey"),
        legend.position = c(0.10, 0.70),
        legend.title = element_blank(),
        legend.key = element_rect(fill = "grey90", colour = "grey90"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "white", color = "grey40", size=0.5),
	plot.margin=unit(c(0,1,1,1),"cm")
)

pl <- ggplot(d, aes(x=t, y=value, color=type)) + geom_point(size=0.1)
pl <- pl + geom_line(size=0.5)
pl <- pl + geom_vline(xintercept = as.numeric(xinter), color = "grey")
pl <- pl + scale_color_manual(values=c("#4daf4a", "#377eb8"))
pl <- pl + theme2

#### top
theme1 <- theme(
  axis.text.y=element_blank(), 
  axis.text.x=element_blank(),
	axis.title=element_blank(),
	axis.ticks=element_blank(),
    legend.background = element_rect(fill = "grey90", color="grey"),
    legend.position = c(0.10, 0.70),
    legend.title = element_blank(),
    legend.key = element_rect(fill = "grey90", colour = "grey90"),
	panel.grid.major = element_line(colour = "grey90", size=0.5, linetype="dashed"),
  panel.grid.minor = element_blank(),
	panel.background = element_rect(fill = "white", color = "grey40", size=0.5),
	plot.margin=unit(c(1,1,-0.1,1),"cm"))

# dataset for geom_segment
sg <- red[, c('t', 'value')]
sg.expand <- rbind(sg, sg)
sg.expand$type <- c(rep("circle", 7), rep("line", 7))


pl1 <- ggplot(da, aes(x=t, y=value)) + theme1 + labs(x=NULL)
pl1 <- pl1 + geom_line(size=0.5, aes(x=t, y=value, color="Percentage of Audience", fill="Percentage of Audience"), data=da)
pl1 <- pl1 + geom_segment(data=sg, aes(xend=t, yend=-Inf), colour = "grey")
pl1 <- pl1 + geom_point(aes(x=t, y=value, color="Beginning of Commercial Break") ,pch=21, size = 1.5, data=sg)
pl1 <- pl1 + scale_color_manual(values=c("violetred2", "violetred3"))
pl1 <- pl1 + guides(color=guide_legend(override.aes=list(shape=c(21,NA),linetype=c(0,1) ), label.position = "left" ))


grid.arrange(pl1, pl, ncol=1, nrow =2, heights = c(0.7, 0.3))


