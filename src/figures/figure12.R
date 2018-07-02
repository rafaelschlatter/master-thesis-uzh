library(ggplot2)
library(scales)
library(grid)
library(gridExtra)
setwd("~/Desktop/Figures/Semi-elasticities")

#ME WORDLWIDE REGION INTERACTION
################################
#This plot is drawn using data from Regression (1) in Table 7.8. The marginal effects (estimates) and
#standard errors (SE) are calculated using Stata's margin command.
TAX_7.8 <- data.frame(
  UN_B=c(seq(1,5,1)),
  Case=c("Worldwide"),
  Estimate=c(-.9127159,-9.53717,1.239605,-1.660541,-17.94044),
  SE=c(.7539217,3.154268,1.125801,.4789178,5.661326))
TAX_7.8
TAX_7.8$Lower <- with(TAX_7.8, Estimate -  1.645 * SE) #create lower bound (90% CI)
TAX_7.8$Upper <- with(TAX_7.8, Estimate +  1.645 * SE) #create lower bound (90% CI)
head(TAX_7.8)
TAX_7.8 # This is the same as the Stata margin output


P1<-ggplot(TAX_7.8,aes(x = UN_B, y = Estimate)) +
  geom_line(size=0.7, col="blue") +
  geom_hline(yintercept = 0, lty="dashed", color="red", size=0.3) +
  geom_errorbar(aes(ymin=Lower, ymax=Upper), width=0.2, color="azure4") +
  geom_point(col="blue") +
  xlab("World region") +
  ylab("Semi-elasticity of EBIT w.r.t. tax diff.") +
  theme_bw() +
  theme(axis.text=element_text(size=6,color="black"),
        axis.title=element_text(size=7),
        axis.ticks.length=unit(-0.1, "cm"),
        axis.ticks = element_line(colour = "black", size = 0.25),
        axis.text.x = element_text(margin=unit(c(0.15,0,0,0), "cm")),
        axis.text.y = element_text(margin=unit(c(0,0.15,0,0), "cm")),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank(),
        panel.border = element_rect(colour = "black", fill=NA, size=0.5),
        strip.background = element_rect(colour = "black", fill = "wheat1")) +
  scale_x_continuous(breaks = round(seq(min(1), max(5), by = 1),1)) +
  scale_y_continuous(breaks = round(seq(min(-28), max(4), by = 5),2)) +
  facet_grid(. ~ Case) +
  theme(axis.text.x=element_blank()) +
  annotate("text", label = "Africa", x = 1, y = -27.5, color = "black", size=2) +
  annotate("text", label = "Americas", x = 2, y = -27.5, color = "black", size=2) +
  annotate("text", label = "Asia", x = 3, y = -27.5, color = "black", size=2) +
  annotate("text", label = "Europe", x = 4, y = -27.5, color = "black", size=2) +
  annotate("text", label = "Oceania", x = 5, y = -27.5, color = "black", size=2) +
  annotate("text", label = "0.3%", x = 1, y = -29, color = "black", size=2) +
  annotate("text", label = "0.2%", x = 2, y = -29, color = "black", size=2) +
  annotate("text", label = "3.0%", x = 3, y = -29, color = "black", size=2) +
  annotate("text", label = "95.8%", x = 4, y = -29, color = "black", size=2) +
  annotate("text", label = "0.7%", x = 5, y = -29, color = "black", size=2) +
  theme(strip.text.x = element_text(size = 7,color="black"))



#ME EUROPEAN REGION INTERACTION
###############################
#This plot is drawn using data from Regression (2) in Table 7.8. The marginal effects (estimates) and
#standard errors (SE) are calculated using Stata's margin command.
TAX_7.8_2 <- data.frame(
  UN_D=c(seq(1,4,1)),
  Case=c("Europe"),
  Estimate=c(-.6361123,-2.724904,-1.24257,-1.233761),
  SE=c(1.484919,.869311,1.124898,.7118025))
TAX_7.8_2
TAX_7.8_2$Lower <- with(TAX_7.8_2, Estimate -  1.645 * SE) #create lower bound (90% CI)
TAX_7.8_2$Upper <- with(TAX_7.8_2, Estimate +  1.645 * SE) #create lower bound (90% CI)
head(TAX_7.8_2)
TAX_7.8_2 # This is the same as the Stata margin output

P2<-ggplot(TAX_7.8_2,aes(x = UN_D, y = Estimate)) +
  geom_line(size=0.7,col="blue") +
  geom_hline(yintercept = 0, lty="dashed", color="red", size=0.3) +
  geom_errorbar(aes(ymin=Lower, ymax=Upper), width=0.2, color="azure4") +
  geom_point(col="blue") +
  xlab("Region in Europe") +
  ylab("Semi-elasticity of EBIT w.r.t. tax diff.") +
  theme_bw() +
  theme(axis.text=element_text(size=6,color="black"),
        axis.title=element_text(size=7),
        axis.ticks.length=unit(-0.1, "cm"),
        axis.ticks = element_line(colour = "black", size = 0.25),
        axis.text.x = element_text(margin=unit(c(0.15,0,0,0), "cm")),
        axis.text.y = element_text(margin=unit(c(0,0.15,0,0), "cm")),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank(),
        panel.border = element_rect(colour = "black", fill=NA, size=0.5),
        strip.background = element_rect(colour = "black", fill = "wheat1")) +
  scale_x_continuous(breaks = round(seq(min(1), max(4), by = 1),1)) +
  scale_y_continuous(breaks = round(seq(min(-5), max(3), by = 1),2)) +
  facet_grid(. ~ Case) +
  theme(axis.text.x=element_blank()) +
  annotate("text", label = "East", x = 1, y = -4.9, color = "black", size=2) +
  annotate("text", label = "North", x = 2, y = -4.9, color = "black", size=2) +
  annotate("text", label = "South", x = 3, y = -4.9, color = "black", size=2) +
  annotate("text", label = "West", x = 4, y = -4.9, color = "black", size=2) +
  annotate("text", label = "19.9%", x = 1, y = -5.2, color = "black", size=2) +
  annotate("text", label = "16.1%", x = 2, y = -5.2, color = "black", size=2) +
  annotate("text", label = "28.9%", x = 3, y = -5.2, color = "black", size=2) +
  annotate("text", label = "35.1%", x = 4, y = -5.2, color = "black", size=2) +
  theme(strip.text.x = element_text(size = 7,color="black"))


#Put plots together and save as pdf
pdf("fig12.pdf", width=5, height=2.25,colormodel="cmyk")
grid.arrange(P1, P2, ncol=2)
dev.off()