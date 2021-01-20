# cat *.log > results.csv

library(dplyr)
library(reshape2)
library(tidyr)
library(ggplot2)

tab <- read.csv("results.csv", header=F, sep=";") %>%
  rename(Architecture=V1,Compiler=V2,Optimization=V3,Ticks=V4)

p <- tab %>% ggplot(aes(x=Ticks, color=Optimization, linetype=Compiler)) +
  facet_wrap(~Architecture,ncol=1,scales="free_y") +
  geom_density() +
  theme_bw() +
  scale_x_continuous("Ticks", limits=c(0000,10000), breaks=seq(0,20000,2000)) +
  scale_y_continuous("Probability") +
  ggtitle("3-rd derivatives evaluation in ticks") +
  scale_color_brewer(palette="Dark2")

ggsave("results.png", p, width=20, height=15,units="cm")

