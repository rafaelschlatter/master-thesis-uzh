library(ggplot2)
library(scales)
library(grid)
library(gridExtra)
setwd("~/Desktop/Figures/Semi-elasticities")


#ME PLOT COMBINED INTERACTIONS (2D, dummy spec)
###############################################
#This plot is drawn using data from regression (3) in Table 8.

#Type1 is firms with below 51% ownership
Type1 <- data.frame(
  LIFA_d=c(0,0,1,1,
           0,0,1,1), #LIFA is fixed at (roughly) the mean, to simplify illustration. The influence of LIFA is rather low as shown before.
  LFA_d=c(0,0,0,0,
          1,1,1,1),
  Estimate=c(.42006,1.273195,.3108977,1.164033,
             -1.229146,-.3760115,-1.338309,-.4851738),
  SE=c(1.521174,1.063711,1.525282,1.051103,
       1.451569,.9775126,1.442702,.9437623), #SE is inserted manually as formula is highly complex
  Case2=c(0,1,0,1,
          0,1,0,1),
  OW=c("OW_51=OW_100=0"),
  ID=c("below mean ln intang., shifting to sub.","below mean ln intang., shifting to parent",
       "above mean ln intang., shifting to sub.","above mean ln intang., shifting to parent",
       "below mean ln intang., shifting to sub.","below mean ln intang., shifting to parent",
       "above mean ln intang., shifting to sub.","above mean ln intang., shifting to parent")
  )
Type1$Lower <- with(Type1, Estimate -  1.645 * SE) #create lower bound (90% CI)
Type1$Upper <- with(Type1, Estimate +  1.645 * SE) #create lower bound (90% CI)
head(Type1)
Type1

#Type2 is firms with between 51% and 99% ownership
Type2 <- data.frame(
  LIFA_d=c(0,0,1,1,
           0,0,1,1), #LIFA is fixed at (roughly) the mean, to simplify illustration. The influence of LIFA is rather low as shown before.
  LFA_d=c(0,0,0,0,
          1,1,1,1),
  Estimate=c(.2856217,1.138757,.1764594,1.029594,
             -1.363585,-.5104498,-1.472747,-.6196121),
  SE=c(1.780603,1.358707,1.787391,1.35319,
       1.75981,1.342921,1.755839,1.322987), #SE is inserted manually as formula is highly complex
  Case2=c(0,1,0,1,
          0,1,0,1),
  OW=c("OW_51=1"),
  ID=c("below mean ln intang., shifting to sub.","below mean ln intang., shifting to parent",
       "above mean ln intang., shifting to sub.","above mean ln intang., shifting to parent",
       "below mean ln intang., shifting to sub.","below mean ln intang., shifting to parent",
       "above mean ln intang., shifting to sub.","above mean ln intang., shifting to parent")
)
Type2$Lower <- with(Type2, Estimate -  1.645 * SE) #create lower bound (90% CI)
Type2$Upper <- with(Type2, Estimate +  1.645 * SE) #create lower bound (90% CI)
head(Type2)
Type2


#Type3 is for wholly-owned firms
Type3 <- data.frame(
  LIFA_d=c(0,0,1,1,
           0,0,1,1), #LIFA is fixed at (roughly) the mean, to simplify illustration. The influence of LIFA is rather low as shown before.
  LFA_d=c(0,0,0,0,
          1,1,1,1),
  Estimate=c(-1.882967,-1.029833,-1.99213,-1.138995,
             -3.532174,-2.679039,-3.641336,-2.788201),
  SE=c(1.609774,.6875628,1.606851,.651274,
       1.584554,.6504976,1.569467,.5799845), #SE is inserted manually as formula is highly complex
  Case2=c(0,1,0,1,
          0,1,0,1),
  OW=c("OW_100=1"),
  ID=c("below mean ln intang., shifting to sub.","below mean ln intang., shifting to parent",
       "above mean ln intang., shifting to sub.","above mean ln intang., shifting to parent",
       "below mean ln intang., shifting to sub.","below mean ln intang., shifting to parent",
       "above mean ln intang., shifting to sub.","above mean ln intang., shifting to parent")
)
Type3$Lower <- with(Type3, Estimate -  1.645 * SE) #create lower bound (90% CI)
Type3$Upper <- with(Type3, Estimate +  1.645 * SE) #create lower bound (90% CI)
head(Type3)
Type3

COMBO<-rbind(Type1, Type2, Type3)
COMBO

group.colors <- c("below mean ln intang., shifting to sub." = "red", "above mean ln intang., shifting to sub." = "green", "below mean ln intang., shifting to parent" ="blue", "above mean ln intang., shifting to parent" = "pink")
pd <- position_dodge(0.3)

pdf("fig10.pdf", width=5.5, height=2.25, colormodel="cmyk")
ggplot(COMBO,aes(x = LFA_d, y = Estimate, group=ID)) +
  geom_hline(yintercept = 0, lty="dashed", color="red", size=0.3) +
  geom_errorbar(aes(ymin=Lower, ymax=Upper), width=.3, position=pd, color="azure4") +
  geom_point(position=pd, aes(shape=ID),col="blue") +
  scale_fill_manual(values=group.colors) +
  xlab("ln fixed assets (categorical variable)") +
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
        legend.position="bottom",
        legend.title = element_blank(),
        legend.text=element_text(size=6),
        legend.key.size = unit(0.2, "cm"),
        legend.margin=margin(t=-0.2, r=0, b=0, l=0, unit="cm"),
        strip.background = element_rect(colour = "black", fill = "wheat1")) +
  scale_x_continuous(breaks = round(seq(min(0), max(1), by = 1),1)) +
  scale_y_continuous(breaks = round(seq(min(-14), max(16), by = 2),1)) +
  facet_grid(.~OW) +
  theme(strip.text.x = element_text(size = 7,color="black")) +
  guides(shape=guide_legend(nrow=2,byrow=TRUE)) +
  annotate("text", label = "~63%", x = 1, y = -6.7, color = "black", size=1.75) +
  annotate("text", label = "~37%", x = 0, y = -6.7, color = "black", size=1.75)
dev.off()