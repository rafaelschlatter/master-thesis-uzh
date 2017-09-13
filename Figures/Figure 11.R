library(ggplot2)
library(scales)
library(grid)
library(gridExtra)
setwd("~/Desktop/Figures/Semi-elasticities")

#ME YEAR INTERACTION (cont.)
############################
#This plot is drawn using data from Regressions (1) and (2) in Table 13 The marginal effects (estimates) and
#standard errors (SE) are calculated using Stata's margin command, or using the corresponding formulas for
#marginal effects and SE's.
TAX_7.7 <- data.frame(
  Year=c(seq(2007, 2015, 1)),
  Case=c("Time interaction (continuous)"))
TAX_7.7

TAX_7.7$Estimate <- with(TAX_7.7,  -173.9128+.0859843*Year) #create estimate
TAX_7.7$SE <- with(TAX_7.7,  sqrt(12926.62+Year*Year*.00320068+2*Year*-6.4322156)) #create standard error
TAX_7.7$Lower <- with(TAX_7.7, Estimate -  1.645 * SE) #create lower bound (90% CI)
TAX_7.7$Upper <- with(TAX_7.7, Estimate +  1.645 * SE) #create lower bound (90% CI)
head(TAX_7.7)
TAX_7.7 # This is the same as the Stata margin output (with rounding difference due to the huge variance of TaxDiff)

#ME YEAR INTERACTION (dummy)
############################
#This plot is drawn using data from Regression (2) in Table 13 The marginal effects (estimates) and
#standard errors (SE) are calculated using Stata's margin command.
TAX_7.7_2 <- data.frame(
  Year=c(seq(2007, 2015, 1)),
  Estimate=c(-1.523534,-2.548719,-2.067693,-1.236179,-1.503128,
             -1.042188,-1.38062,-1.420603,-1.33989),
  SE=c(.4574853,.5639102,.5613999,.543275,.5333607,
       .5372323,.5444893,.5421048,.5496388),
  Case=c("Time interaction (categorical)"))
TAX_7.7_2

TAX_7.7_2$Lower <- with(TAX_7.7_2, Estimate -  1.645 * SE) #create lower bound (90% CI)
TAX_7.7_2$Upper <- with(TAX_7.7_2, Estimate +  1.645 * SE) #create lower bound (90% CI)
head(TAX_7.7_2)
TAX_7.7_2 # This is the same as the Stata margin output (with rounding difference due to the huge variance of TaxDiff)

COMBO<-rbind(TAX_7.7, TAX_7.7_2)
COMBO

pdf("fig11.pdf", width=5, height=2.25,colormodel="cmyk")
ggplot(COMBO,aes(x = Year, y = Estimate)) +
  geom_line(size=0.7,col="blue") +
  geom_hline(yintercept = 0, lty="dashed", color="red", size=0.3) +
  #geom_line(mapping = aes(y = Lower), lty = "dashed", size=0.3) +
  #geom_line(mapping = aes(y = Upper), lty = "dashed", size=0.3) +
  geom_ribbon(aes(ymin=Lower, ymax=Upper), alpha=0.1) + 
  xlab("Time in years") +
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
  scale_x_continuous(breaks = round(seq(min(2007), max(2015), by = 1),2)) +
  scale_y_continuous(breaks = round(seq(min(-14), max(16), by = 0.5),2)) +
  facet_grid(. ~ Case) +
  annotate("text", label = "10", x = 2007, y = -3.75, color = "black", size=2) +
  annotate("text", label = "10", x = 2008, y = -3.75, color = "black", size=2) +
  annotate("text", label = "9.2", x = 2009, y = -3.75, color = "black", size=2) +
  annotate("text", label = "10.9", x = 2010, y = -3.75, color = "black", size=2) +
  annotate("text", label = "11.5", x = 2011, y = -3.75, color = "black", size=2) +
  annotate("text", label = "11.7", x = 2012, y = -3.75, color = "black", size=2) +
  annotate("text", label = "12.5", x = 2013, y = -3.75, color = "black", size=2) +
  annotate("text", label = "12.6", x = 2014, y = -3.75, color = "black", size=2) +
  annotate("text", label = "11.6", x = 2015, y = -3.75, color = "black", size=2) +
  theme(strip.text.x = element_text(size = 7,color="black"))
dev.off()