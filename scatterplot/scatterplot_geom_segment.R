gradient <- read.csv("results-gradient-boosting.csv")
head(gradient)
p <- ggplot(gradient, aes(pred, y))
p <- p + geom_point(alpha = 0.4)
p <- p + labs(x = "Predicted", y = "Measured")
p <- p + ggtitle("Measured Vs Predicted Passing Rate")
line_df <- data.frame(x = c(0, 0, 3), 
                      y = c(0, 3, 0), 
                      xend = c(20, 18, 21),
                      yend = c(20, 21, 18),
                      group = c("Measured = Predicted", "Measured = Predicted - 3%",  "Measured = Predicted + 3%"))

p <- p + geom_segment(data = line_df, 
                      aes(x = x, y = y, xend = xend, yend = yend, linetype=group), 
                      show.legend = TRUE,
                      alpha = 0.3)
p <- p + theme(plot.title = element_text(hjust = 0.5),
               legend.position = c(0.8, 0.2), 
               legend.title = element_blank(),
               legend.key = element_rect())
p