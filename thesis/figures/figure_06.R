library(ggplot2)
library(scales)
library(grid)
library(Cairo)
library(extrafont)
setwd("~/Desktop/Figures/Semi-elasticities")


#ME PLOT QUADRATIC INTERACTION
##############################
#This plot is drawn using data from Regression (4) in Table 6. The marginal effects (estimates) and
#standard errors (SE) are calculated using Stata's margin command.
TAX_QUAD <- data.frame(
  TaxDiff=c(seq(-0.25, 0.4 ,0.05)),
  Case=c("Quadratic regression")
)
TAX_QUAD$Estimate <- with(TAX_QUAD,  -1.5041+.3630685*(TaxDiff*2)) #create Estimate
TAX_QUAD$SE <- with(TAX_QUAD,  sqrt(.37834744 + 4 * TaxDiff * TaxDiff *9.5836787 + 4 * TaxDiff * -1.3676307)) #create standard error
TAX_QUAD$Lower <- with(TAX_QUAD, Estimate -  1.645 * SE) #create lower bound (90% CI)
TAX_QUAD$Upper <- with(TAX_QUAD, Estimate +  1.645 * SE) #create lower bound (90% CI)
head(TAX_QUAD)
TAX_QUAD #This is the same as in the margins command in Stata.


pdf("fig6.pdf",width=3, height=2.25, colormodel="cmyk")
ggplot(TAX_QUAD, aes(x = TaxDiff, y = Estimate)) +
  geom_segment(aes(x=-0.03,xend=0.16,y=0,yend=0),size=1.5, color="gray", alpha=0.5) +
  geom_hline(yintercept = 0, lty="dashed", color="red", size=0.3) +
  #geom_line(mapping = aes(y = Lower), lty = "dashed", size=0.3) +
  #geom_line(mapping = aes(y = Upper), lty = "dashed", size=0.3) +
  geom_ribbon(aes(ymin=Lower, ymax=Upper), alpha=0.1) +
  geom_line(size=0.7,col="blue") +
  xlab("Tax differential") +
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
  scale_x_continuous(breaks = round(seq(min(-0.25), max(0.4), by = 0.1),4)) +
  scale_y_continuous(breaks = round(seq(min(-5), max(2), by = 1),1)) +
  facet_grid(.~Case) +
  theme(strip.text.x = element_text(size = 7,color="black"))
dev.off()
