library(ggplot2)
library(directlabels)
library(gridExtra)
library(reshape)
library(reshape2)
library(GGally)
library(hexbin)
library(viridisLite)
library(viridis)
library(car)
setwd("~/Desktop/Figures/Regression Diagnostics + Histograms")
RD_DATA = read.csv("Regression Diagnostics Data.csv", header = TRUE, stringsAsFactors=FALSE)
head(RD_DATA)
attach(RD_DATA)

#CREATE RESIDUAL PLOT (Figure 16)
#################################
#SCATTERPLOT
SCATTER <- ggplot(RD_DATA, aes(x=PRED_FIXED, y=RES)) + geom_point(alpha=0, size=1.5, color="black", shape=16) +
            xlab("Linear prediction of log EBIT including fixed effect") +
            ylab("Residuals") +
            theme(legend.position="left",axis.text=element_text(size=7), axis.title=element_text(size=9)) +
            stat_binhex(binwidth=c(0.25, 0.3)) +
            geom_hline(yintercept = 0, lty="dashed", color="red", size=0.3) +
            scale_fill_viridis() +
            theme_bw() +
            theme(axis.text=element_text(size=6,color="black"), axis.title=element_text(size=7),
                  legend.position= c(0.9,0.25), legend.key.size = unit(0.4, "cm"),
                  axis.ticks.length=unit(-0.1, "cm"),
                  axis.ticks = element_line(colour = "black", size = 0.25),
                  axis.text.x = element_text(margin=unit(c(0.15,0,0,0), "cm")),
                  axis.text.y = element_text(margin=unit(c(0,0.15,0,0), "cm")),
                  panel.grid.minor = element_blank(),panel.grid.major = element_blank(),
                  panel.border = element_rect(colour = "black", fill=NA, size=0.5),
                  legend.background = element_rect(fill=alpha(0.4)),
                  legend.text=element_text(size=6), legend.title = element_text(size=7))
SCATTER

#RESIDUAL HISTOGRAM + DENSITY
RES <-ggplot(RD_DATA, aes(x=RES)) +
                geom_histogram(aes(y=..density..), bins=40, fill=NA, col="black", size=0.4) +
                geom_density(size=0.4,col="blue") +
                stat_function(fun = dnorm, 
                args = list(mean = mean(RD_DATA$RES), sd = sd(RD_DATA$RES)),
                lty="solid", size=0.4,col="red") +
                #geom_rug(sides="l", size=0.5) +
                coord_flip() + 
                theme_bw() +
                theme(axis.text=element_text(size=6,color="black"), axis.title=element_text(size=7),
                      axis.title.y=element_blank(), legend.position="none",
                      axis.ticks.length=unit(-0.1, "cm"),
                      axis.ticks = element_line(colour = "black", size = 0.25),
                      panel.border = element_rect(colour = "black", fill=NA, size=0.5),
                      axis.text.x = element_text(margin=unit(c(0.15,0,0,0), "cm")),
                      axis.text.y = element_text(margin=unit(c(0,0.15,0,0), "cm")),
                      panel.grid.minor = element_blank(),panel.grid.major = element_blank())
RES

#PREDICTION HISTOGRAM + DENSITY
PRED <-ggplot(RD_DATA, aes(x=PRED_FIXED)) +
  geom_histogram(aes(y=..density..), bins=40, fill=NA, col="black", size=0.4) +
  geom_density(size=0.4,col="blue") +
  stat_function(fun = dnorm, 
                args = list(mean = mean(RD_DATA$PRED_FIXED), sd = sd(RD_DATA$PRED_FIXED)),
                lty="solid", size=0.4,col="red") +
                #geom_rug(sides="b", size=0.5) +
                theme_bw() +
                theme(axis.text=element_text(size=6,color="black"), axis.title=element_text(size=7),
                axis.title.x=element_blank(), legend.position="none",
                axis.ticks.length=unit(-0.1, "cm"),
                axis.ticks = element_line(colour = "black", size = 0.25),
                panel.border = element_rect(colour = "black", fill=NA, size=0.5),
                axis.text.x = element_text(margin=unit(c(0.15,0,0,0), "cm")),
                axis.text.y = element_text(margin=unit(c(0,0.15,0,0), "cm")),
                panel.grid.minor = element_blank(),panel.grid.major = element_blank())
PRED

#EMPTY PLOT TO ARRANGE THINGS
EMPTY <- ggplot(RD_DATA, aes(x = PRED_FIXED, y = RES)) +
  geom_blank() +
  theme(axis.text = element_blank(),
        axis.title = element_blank(),
        line = element_blank(),
        panel.background = element_blank())
EMPTY

pdf("fig16.pdf",width=6,height=3.5,colormodel="cmyk")
grid.arrange(PRED, EMPTY, SCATTER, RES, ncol=2, nrow=2, widths = c(3, 1), heights = c(1.3, 3))
dev.off()

#QQ-Plot to assess normality of residuals (Figure 17)
#####################################################
QQ<-ggplot(RD_DATA, aes(sample=RES))+stat_qq(shape=21) +
  theme_bw() +
  xlab("Theoretical quantiles") +
  ylab("Sample quantiles") +
  theme(axis.text=element_text(size=6,color="black"), axis.title=element_text(size=7),
        legend.position="none",
        axis.ticks.length=unit(-0.1, "cm"),
        axis.ticks = element_line(colour = "black", size = 0.25),
        panel.border = element_rect(colour = "black", fill=NA, size=0.5),
        axis.text.x = element_text(margin=unit(c(0.15,0,0,0), "cm")),
        axis.text.y = element_text(margin=unit(c(0,0.15,0,0), "cm")),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank()) +
  geom_abline(intercept = 0, slope = 1, lty="dashed", size=0.5,col="red")

#This figure will not be scalable in the thesis due to the large file size of a vector based graphic.
pdf("fig17.pdf", width=3, height=2,colormodel="cmyk")
QQ
dev.off()



#Alternativ:
library(car)
QQ2<-qqPlot(RD_DATA$RES_FIXED)
pdf("fig17.pdf", width=5, height=3)
QQ2
dev.off()
