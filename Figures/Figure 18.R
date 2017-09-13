library(ggplot2)
library(directlabels)
library(gridExtra)
library(reshape)
library(reshape2)
library(GGally)
library(hexbin)
library(viridisLite)
library(viridis)
setwd("~/Desktop/Figures/Regression Diagnostics + Histograms")
RD_DATA = read.csv("Regression Diagnostics Data.csv", header = TRUE, stringsAsFactors=FALSE)
head(RD_DATA)

#This is Figure 18.

GDP <- ggplot(RD_DATA, aes(x=LGDP_per_capita_current_LCU, y=LEBIT)) + geom_point(alpha=0, size=1.5, color="black", shape=16) +
  xlab("ln GDP per capita in local currency") +
  ylab("ln EBIT") +
  theme(legend.position="left",axis.text=element_text(size=6), axis.title=element_text(size=7)) +
  stat_binhex(binwidth=c(0.15, 0.4)) +
  scale_fill_viridis() +
  theme_bw() +
  theme(axis.text=element_text(size=6,color="black"), axis.title=element_text(size=7),
        legend.position= c(0.9,0.25), legend.key.size = unit(0.3, "cm"),
        axis.ticks.length=unit(-0.1, "cm"),
        axis.ticks = element_line(colour = "black", size = 0.25),
        panel.border = element_rect(colour = "black", fill=NA, size=0.5),
        axis.text.x = element_text(margin=unit(c(0.15,0,0,0), "cm")),
        axis.text.y = element_text(margin=unit(c(0,0.15,0,0), "cm")),
        panel.grid.minor = element_blank(),panel.grid.major = element_blank(),
        legend.background = element_rect(fill=alpha(0.4)),
        legend.text=element_text(size=6), legend.title = element_text(size=7))
GDP

LFA <- ggplot(RD_DATA, aes(x=LFA, y=LEBIT)) + geom_point(alpha=0, size=1.5, color="black", shape=16) +
  xlab("ln Fixed assets") +
  ylab("ln EBIT") +
  stat_binhex(binwidth=c(0.4, 0.4)) +
  scale_fill_viridis() +
  theme_bw() +
  theme(axis.text=element_text(size=6,color="black"), axis.title=element_text(size=7),
        legend.position= c(0.9,0.25), legend.key.size = unit(0.3, "cm"),
        axis.ticks.length=unit(-0.1, "cm"),
        axis.ticks = element_line(colour = "black", size = 0.25),
        panel.border = element_rect(colour = "black", fill=NA, size=0.5),
        axis.text.x = element_text(margin=unit(c(0.15,0,0,0), "cm")),
        axis.text.y = element_text(margin=unit(c(0,0.15,0,0), "cm")),
        panel.grid.minor = element_blank(),panel.grid.major = element_blank(),
        legend.background = element_rect(fill=alpha(0.4)),
        legend.text=element_text(size=6), legend.title = element_text(size=7))
LFA

LCEmployees <- ggplot(RD_DATA, aes(x=LCEmployees, y=LEBIT)) + geom_point(alpha=0, size=1.5, color="black", shape=16) +
  xlab("ln Costs of employees") +
  ylab("ln EBIT") +
  stat_binhex(binwidth=c(0.3, 0.4)) +
  scale_fill_viridis() +
  theme_bw() +
  theme(axis.text=element_text(size=6,color="black"), axis.title=element_text(size=7),
        legend.position= c(0.9,0.25), legend.key.size = unit(0.3, "cm"),
        axis.ticks.length=unit(-0.1, "cm"),
        axis.ticks = element_line(colour = "black", size = 0.25),
        panel.border = element_rect(colour = "black", fill=NA, size=0.5),
        axis.text.x = element_text(margin=unit(c(0.15,0,0,0), "cm")),
        axis.text.y = element_text(margin=unit(c(0,0.15,0,0), "cm")),
        panel.grid.minor = element_blank(),panel.grid.major = element_blank(),
        legend.background = element_rect(fill=alpha(0.4)),
        legend.text=element_text(size=6), legend.title = element_text(size=7))
LCEmployees

TaxDiff <- ggplot(RD_DATA, aes(x=TaxDiff, y=LEBIT)) + geom_point(alpha=0, size=1.5, color="black", shape=16) +
  xlab("Tax differential") +
  ylab("ln EBIT") +
  stat_binhex(binwidth=c(0.01, 0.4)) +
  scale_fill_viridis() +
  theme_bw() +
  theme(axis.text=element_text(size=6,color="black"), axis.title=element_text(size=7),
        legend.position= c(0.9,0.25), legend.key.size = unit(0.3, "cm"),
        axis.ticks.length=unit(-0.1, "cm"),
        axis.ticks = element_line(colour = "black", size = 0.25),
        panel.border = element_rect(colour = "black", fill=NA, size=0.5),
        axis.text.x = element_text(margin=unit(c(0.15,0,0,0), "cm")),
        axis.text.y = element_text(margin=unit(c(0,0.15,0,0), "cm")),
        panel.grid.minor = element_blank(),panel.grid.major = element_blank(),
        legend.background = element_rect(fill=alpha(0.4)),
        legend.text=element_text(size=6), legend.title = element_text(size=7))
TaxDiff

Intangibles<- ggplot(RD_DATA, aes(x=LIFA, y=LEBIT)) + geom_point(alpha=0, size=1.5, color="black", shape=16) +
  xlab("ln Intangible fixed assets") +
  ylab("ln EBIT") +
  stat_binhex(binwidth=c(0.4, 0.4)) +
  scale_fill_viridis() +
  theme_bw() +
  theme(axis.text=element_text(size=6,color="black"), axis.title=element_text(size=7),
        legend.position= c(0.9,0.25), legend.key.size = unit(0.3, "cm"),
        axis.ticks.length=unit(-0.1, "cm"),
        axis.ticks = element_line(colour = "black", size = 0.25),
        panel.border = element_rect(colour = "black", fill=NA, size=0.5),
        axis.text.x = element_text(margin=unit(c(0.15,0,0,0), "cm")),
        axis.text.y = element_text(margin=unit(c(0,0.15,0,0), "cm")),
        panel.grid.minor = element_blank(),panel.grid.major = element_blank(),
        legend.background = element_rect(fill=alpha(0.4)),
        legend.text=element_text(size=6), legend.title = element_text(size=7))
Intangibles

Leverage<- ggplot(RD_DATA, aes(x=LDED, y=LEBIT)) + geom_point(alpha=0, size=1.5, color="black", shape=16) +
  xlab("ln Debt over ln total assets") +
  ylab("ln EBIT") +
  stat_binhex(binwidth=c(0.2, 0.4)) +
  scale_fill_viridis() +
  theme_bw() +
  theme(axis.text=element_text(size=6,color="black"), axis.title=element_text(size=7),
        legend.position= c(0.9,0.25), legend.key.size = unit(0.3, "cm"),
        axis.ticks.length=unit(-0.1, "cm"),
        axis.ticks = element_line(colour = "black", size = 0.25),
        panel.border = element_rect(colour = "black", fill=NA, size=0.5),
        axis.text.x = element_text(margin=unit(c(0.15,0,0,0), "cm")),
        axis.text.y = element_text(margin=unit(c(0,0.15,0,0), "cm")),
        panel.grid.minor = element_blank(),panel.grid.major = element_blank(),
        legend.background = element_rect(fill=alpha(0.4)),
        legend.text=element_text(size=6), legend.title = element_text(size=7))
Leverage

#Put plots together and save as pdf
pdf("fig18.pdf", width=5, height=6,colormodel="cmyk")
grid.arrange(GDP, LFA, LCEmployees, TaxDiff, Intangibles, Leverage, ncol=2, nrow=3)
dev.off()