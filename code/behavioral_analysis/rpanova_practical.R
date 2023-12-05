library(tidyverse)


# SET PATH
setwd("/Users/denisekittelmann/Downloads/")

# READ IN DATA
rm_aov <- read.csv('/Users/denisekittelmann/downloads/rmanova_data.csv')

# CONVERT IV's into factors
rm_aov$Runs <- as.factor(rm_aov$Runs)
rm_aov$TaskType <- as.factor(rm_aov$TaskType)

# RUN AOV MODEL 
tt <- aov(Values ~ TaskType * Runs + Error(SubjectID/(TaskType*Runs)), rm_aov)

# GET ANOVA TABLE 
summary(tt)

# PLOT RESULTS
aov_plot <- ggplot(rm_aov, aes(x=TaskType, y=Values)) + 
  geom_boxplot(width=0.5,
               color="black",
               fill= c("1" = "#E69F00", "2" = "#2e4057")) +
  scale_x_discrete(labels = c("1" = "Alternating", "2" = "Simultaneoues")) +
  labs(y = "Switchtrials") + 
  theme_classic() +
  theme(legend.position = "none")
  

ggsave("aov_plot.png", width = 10, height = 6)

