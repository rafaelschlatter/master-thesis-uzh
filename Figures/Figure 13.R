library(ggplot2)
library(gridExtra)

setwd("~/Desktop/Figures/Regression Diagnostics + Histograms")
RD_DATA = read.csv("Regression Diagnostics Data.csv", header = TRUE, stringsAsFactors=FALSE)
head(RD_DATA)

#This is Figure 13.

#LEBIT
EBIT<-ggplot(RD_DATA, aes(x=LEBIT)) +
  geom_histogram(aes(y=..density..), bins=40, fill=NA, col="black", size=0.4) +
  geom_density(size=0.4,col="blue") +
  stat_function(fun = dnorm, 
                args = list(mean = mean(RD_DATA$LEBIT), sd = sd(RD_DATA$LEBIT)),  
                lty="solid", size=0.4,col="red") +
  #geom_rug(sides="b", size=0.25) +
  xlab("ln EBIT") +
  theme_bw() +
  theme(axis.text=element_text(size=6,color="black"), axis.title=element_text(size=7),
        axis.ticks.length=unit(-0.1, "cm"),
        axis.ticks = element_line(colour = "black", size = 0.25),
        panel.border = element_rect(colour = "black", fill=NA, size=0.5),
        axis.text.x = element_text(margin=unit(c(0.15,0,0,0), "cm")),
        axis.text.y = element_text(margin=unit(c(0,0.15,0,0), "cm")),
        panel.grid.minor = element_blank(),panel.grid.major = element_blank())

#GDP per capita
GDP<-ggplot(RD_DATA, aes(x=LGDP_per_capita_current_LCU)) +
  geom_histogram(aes(y=..density..), bins=40, fill=NA, col="black", size=0.4) +
  geom_density(size=0.4,col="blue") +
  stat_function(fun = dnorm, 
                args = list(mean = mean(RD_DATA$LGDP_per_capita_current_LCU), sd = sd(RD_DATA$LGDP_per_capita_current_LCU)),  
                lty="solid", size=0.4,col="red") +
  #geom_rug(sides="b", size=0.25) +
  xlab("ln GDP per capita in local currency") +
  theme_bw() +
  theme(axis.text=element_text(size=6,color="black"), axis.title=element_text(size=7),
        axis.ticks.length=unit(-0.1, "cm"),
        axis.ticks = element_line(colour = "black", size = 0.25),
        panel.border = element_rect(colour = "black", fill=NA, size=0.5),
        axis.text.x = element_text(margin=unit(c(0.15,0,0,0), "cm")),
        axis.text.y = element_text(margin=unit(c(0,0.15,0,0), "cm")),
        panel.grid.minor = element_blank(),panel.grid.major = element_blank())

#CAPITAL
LFA<-ggplot(RD_DATA, aes(x=LFA)) +
  geom_histogram(aes(y=..density..), bins=40, fill=NA, col="black", size=0.4) +
  geom_density(size=0.4,col="blue") +
  stat_function(fun = dnorm, 
                args = list(mean = mean(RD_DATA$LFA), sd = sd(RD_DATA$LFA)),  
                lty="solid", size=0.4,col="red") +
  #geom_rug(sides="b", size=0.25) +
  xlab("ln fixed assets") +
  theme_bw() +
  theme(axis.text=element_text(size=6,color="black"), axis.title=element_text(size=7),
        axis.ticks.length=unit(-0.1, "cm"),
        axis.ticks = element_line(colour = "black", size = 0.25),
        panel.border = element_rect(colour = "black", fill=NA, size=0.5),
        axis.text.x = element_text(margin=unit(c(0.15,0,0,0), "cm")),
        axis.text.y = element_text(margin=unit(c(0,0.15,0,0), "cm")),
        panel.grid.minor = element_blank(),panel.grid.major = element_blank())

#LABOR
LCEmployees<-ggplot(RD_DATA, aes(x=LCEmployees)) +
  geom_histogram(aes(y=..density..), bins=40, fill=NA, col="black", size=0.4) +
  geom_density(size=0.4,col="blue") +
  stat_function(fun = dnorm, 
                args = list(mean = mean(RD_DATA$LCEmployees), sd = sd(RD_DATA$LCEmployees)),  
                lty="solid", size=0.4,col="red") +
  #geom_rug(sides="b", size=0.25) +
  xlab("ln costs of employees") +
  theme_bw() +
  theme(axis.text=element_text(size=6,color="black"), axis.title=element_text(size=7),
        axis.ticks.length=unit(-0.1, "cm"),
        axis.ticks = element_line(colour = "black", size = 0.25),
        panel.border = element_rect(colour = "black", fill=NA, size=0.5),
        axis.text.x = element_text(margin=unit(c(0.15,0,0,0), "cm")),
        axis.text.y = element_text(margin=unit(c(0,0.15,0,0), "cm")),
        panel.grid.minor = element_blank(),panel.grid.major = element_blank())

#TaxDiff
TaxDiff<-ggplot(RD_DATA, aes(x=TaxDiff)) +
  geom_histogram(aes(y=..density..), bins=40, fill=NA, col="black", size=0.4) +
  geom_density(size=0.4,col="blue") +
  stat_function(fun = dnorm, 
                args = list(mean = mean(RD_DATA$TaxDiff), sd = sd(RD_DATA$TaxDiff)),  
                lty="solid", size=0.4,col="red") +
  #geom_rug(sides="b", size=0.25) +
  xlab("Tax differential") +
  theme_bw() +
  theme(axis.text=element_text(size=6,color="black"), axis.title=element_text(size=7),
        axis.ticks.length=unit(-0.1, "cm"),
        axis.ticks = element_line(colour = "black", size = 0.25),
        panel.border = element_rect(colour = "black", fill=NA, size=0.5),
        axis.text.x = element_text(margin=unit(c(0.15,0,0,0), "cm")),
        axis.text.y = element_text(margin=unit(c(0,0.15,0,0), "cm")),
        panel.grid.minor = element_blank(),panel.grid.major = element_blank())


#Intangibles
Intangibles<-ggplot(RD_DATA, aes(x=LIFA)) +
  geom_histogram(aes(y=..density..), bins=40, fill=NA, col="black", size=0.4) +
  geom_density(size=0.4,col="blue") +
  stat_function(fun = dnorm, 
                args = list(mean = mean(RD_DATA$LIFA,na.rm = TRUE), sd = sd(RD_DATA$LIFA,na.rm = TRUE)),  
                lty="solid", size=0.4,col="red") +
  #geom_rug(sides="b", size=0.25) +
  xlab("ln intangible fixed assets") +
  theme_bw() +
  theme(axis.text=element_text(size=6,color="black"), axis.title=element_text(size=7),
        axis.ticks.length=unit(-0.1, "cm"),
        axis.ticks = element_line(colour = "black", size = 0.25),
        panel.border = element_rect(colour = "black", fill=NA, size=0.5),
        axis.text.x = element_text(margin=unit(c(0.15,0,0,0), "cm")),
        axis.text.y = element_text(margin=unit(c(0,0.15,0,0), "cm")),
        panel.grid.minor = element_blank(),panel.grid.major = element_blank())

#Leverage
Leverage<-ggplot(RD_DATA, aes(x=LDED)) +
  geom_histogram(aes(y=..density..), bins=40, fill=NA, col="black", size=0.4) +
  geom_density(size=0.4,col="blue") +
  stat_function(fun = dnorm, 
                args = list(mean = mean(RD_DATA$LDED,na.rm = TRUE), sd = sd(RD_DATA$LDED,na.rm = TRUE)),  
                lty="solid", size=0.4,col="red") +
  #geom_rug(sides="b", size=0.25) +
  xlab("ln debt over ln total assets") +
  theme_bw() +
  theme(axis.text=element_text(size=6,color="black"), axis.title=element_text(size=7),
        axis.ticks.length=unit(-0.1, "cm"),
        axis.ticks = element_line(colour = "black", size = 0.25),
        panel.border = element_rect(colour = "black", fill=NA, size=0.5),
        axis.text.x = element_text(margin=unit(c(0.15,0,0,0), "cm")),
        axis.text.y = element_text(margin=unit(c(0,0.15,0,0), "cm")),
        panel.grid.minor = element_blank(),panel.grid.major = element_blank())

#Put plots together and save as pdf
pdf("fig13.pdf", width=3, height=9.5,colormodel="cmyk")
grid.arrange(EBIT, GDP, LFA, LCEmployees, TaxDiff, Intangibles, Leverage, ncol=1, nrow=7)
dev.off()