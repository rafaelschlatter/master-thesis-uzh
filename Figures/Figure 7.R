library(ggplot2)
library(scales)
library(grid)
library(gridExtra)
setwd("~/Desktop/Figures/Semi-elasticities")

#ME PLOT CAPITAL INTERACTION
############################
#This plot is drawn using data from Regression (1) in Table 7. The marginal effects (estimates) and
#standard errors (SE) are calculated using Stata's margin command.
TAX_7.2 <- data.frame(
  LFA=c(1:25),
  Case=c("Capital interaction"))

TAX_7.2$Estimate <- with(TAX_7.2,  3.63736 -.3457075*LFA) #create estimate
TAX_7.2$SE <- with(TAX_7.2,  sqrt(3.4790167+LFA*LFA*.01507529+2*LFA*-.22236125)) #create standard error
TAX_7.2$Lower <- with(TAX_7.2, Estimate -  1.645 * SE) #create lower bound (90% CI)
TAX_7.2$Upper <- with(TAX_7.2, Estimate +  1.645 * SE) #create lower bound (90% CI)
head(TAX_7.2)
TAX_7.2 # This is the same as the Stata margin output.

#Plot for Regression (1) in Table 7
P1<-ggplot(TAX_7.2, aes(x = LFA, y = Estimate)) +
  geom_segment(aes(x=10.4,xend=18.5,y=0,yend=0),size=1.5, color="gray", alpha=0.5) +
  geom_line(size=0.7,col="blue") +
  geom_hline(yintercept = 0, lty="dashed", color="red", size=0.3) +
  #geom_line(mapping = aes(y = Lower), lty = "dashed", size=0.3) +
  #geom_line(mapping = aes(y = Upper), lty = "dashed", size=0.3) +
  geom_ribbon(aes(ymin=Lower, ymax=Upper), alpha=0.1) +
  xlab("ln fixed assets") +
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
        strip.background = element_rect(colour = "black",
                                        fill = "wheat1")) +
  scale_x_continuous(breaks = round(seq(min(1), max(25), by = 4),1)) +
  scale_y_continuous(breaks = round(seq(min(-8), max(7), by = 3),1)) +
  expand_limits(y = c(-8, 7)) +
  facet_grid(.~Case) +
  theme(strip.text.x = element_text(size = 7,color="black")) 

#ME PLOT INTANGIBLES INTERACTION
################################
#This plot is drawn using data from Regression (3) in Table 7 The marginal effects (estimates) and
#standard errors (SE) are calculated using Stata's margin command.
TAX_7.2_2 <- data.frame(
  LIFA=c(-5:24),
  Case=c("Intangibles interaction"))

TAX_7.2_2$Estimate <- with(TAX_7.2_2, .9392133 -.15954  * LIFA) #create Marginal effect estimate
TAX_7.2_2$SE <- with(TAX_7.2_2,  sqrt(1.364913+(LIFA^2)*.00771975+2*LIFA*-.09246069)) #calculate SE (for formula see Matt Golder website)
TAX_7.2_2$Lower <- with(TAX_7.2_2, Estimate -  1.645 * SE) #create lower bound (90% CI)
TAX_7.2_2$Upper <- with(TAX_7.2_2, Estimate +  1.645 * SE) #create lower bound (90% CI)
head(TAX_7.2_2)
TAX_7.2_2 #data.frame is identical to Stata output from margins command (except 90 instead of 95 CI)

#Plot for Regression (3) in Table 7
P2<-ggplot(TAX_7.2_2, aes(x = LIFA, y = Estimate)) +
  geom_segment(aes(x=6.09,xend=16.24,y=0,yend=0),size=1.5, color="gray", alpha=0.5) +
  geom_line(size=0.7,col="blue") +
  geom_hline(yintercept = 0, lty="dashed", color="red", size=0.3) +
  #geom_line(mapping = aes(y = Lower), lty = "dashed", size=0.3) +
  #geom_line(mapping = aes(y = Upper), lty = "dashed", size=0.3) +
  geom_ribbon(aes(ymin=Lower, ymax=Upper), alpha=0.1) +
  xlab("ln intangible fixed assets") +
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
        strip.background = element_rect(colour = "black",
                                        fill = "wheat1")) +
  scale_x_continuous(breaks = round(seq(min(-5), max(24), by = 4),1)) +
  scale_y_continuous(breaks = round(seq(min(-8), max(7), by = 3),1)) +
  expand_limits(y = c(-8, 7)) +
  facet_grid(.~Case) +
  theme(strip.text.x = element_text(size = 7,color="black"))

#Put plots together and save as pdf
pdf("fig7.pdf", width=5.5, height=2.25,colormodel="cmyk")
grid.arrange(P1, P2, ncol=2)
dev.off()