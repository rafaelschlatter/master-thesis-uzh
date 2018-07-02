library(ggplot2)
library(scales)
library(grid)
library(gridExtra)
setwd("~/Desktop/Figures/Semi-elasticities")

#ME PLOT COMBINED INTERACTIONS (2D)
###################################
#This plot is drawn using data from Regression (1) in Table 8

#Type1 is whole range LFA, LIFA=11, OW_100=1, OW_51=0 and Case2=1
Type1 <- data.frame(
  LIFA=c(11), #LIFA is fixed at (roughly) the mean, to simplify illustration. The influence of LIFA is rather low as shown before.
  LFA=c(1:25),
  SE=c(2.71858,2.535684,2.353852,2.173349,1.994537,
       1.817915,1.644189,1.474383,1.310021,1.153434,
       1.00825,.8801317,.7775602,.7116687,.6930003,
       .7252109,.802195,.9126922,1.046137,1.194865,
       1.353848,1.519873,1.690865,1.86546,2.042735), #SE is inserted manually as formula is highly complex
  Case=c("OW_100=1, shifting to parent"),
  Case2=c("A"),
  OW=c("OW_100=1"),
  DIR=c("shifting to parent"))
Type1$Estimate <- with(Type1, 9.787941 -.6120982  * LFA -.0268231*11-3.613203+1.332656) #Create estimate
Type1$Lower <- with(Type1, Estimate -  1.645 * SE) #create lower bound (90% CI)
Type1$Upper <- with(Type1, Estimate +  1.645 * SE) #create lower bound (90% CI)
head(Type1)
Type1

#Type2 is whole range LFA, LIFA=11, OW_51=1, OW_100=0 and Case2=1
Type2 <- data.frame(
  LIFA=c(11), #LIFA is fixed at (roughly) the mean, to simplify illustration. The influence of LIFA is rather low as shown before.
  LFA=c(1:25),
  SE=c(2.987531,2.822227,2.660167,2.501982,2.348457,
       2.200565,2.059521,1.92683,1.804335,1.694249,
       1.599137,1.521809,1.465084,1.431413,1.422435,
       1.438612,1.479118,1.542038,1.624769,1.724464,
       1.838363,1.963998,2.099262,2.242413,2.392037), #SE is inserted manually as formula is highly complex
  Case=c("OW_51=1, shifting to parent"),
  Case2=c("B"),
  OW=c("OW_51=1"),
  DIR=c("shifting to parent"))
Type2$Estimate <- with(Type2, 9.787941 -.6120982  * LFA -.0268231*11+.3135587+1.332656) #Create estimate
Type2$Lower <- with(Type2, Estimate -  1.645 * SE) #create lower bound (90% CI)
Type2$Upper <- with(Type2, Estimate +  1.645 * SE) #create lower bound (90% CI)
head(Type2)
Type2

#Type3 is whole range LFA, LIFA=11, OW_100=OW_51=0 and Case2=1
Type3 <- data.frame(
  LIFA=c(11), #LIFA is fixed at (roughly) the mean, to simplify illustration. The influence of LIFA is rather low as shown before.
  LFA=c(1:25),
  SE=c(3.061492,2.882503,2.704962,2.529174,2.355531,
       2.184544,2.01689,1.853473,1.695519,1.544704,
       1.403332,1.27455,1.162547,1.072595,1.010598,
       .9818665,.9893024,1.032124,1.106231,1.205868,
       1.32529,1.459648,1.605197,1.75916,1.919515), #SE is inserted manually as formula is highly complex
  Case=c("OW_51=OW_100=0, shifting to parent"),
  Case2=c("C"),
  OW=c("OW_51=OW_100=0"),
  DIR=c("shifting to parent"))
Type3$Estimate <- with(Type3, 9.787941 -.6120982  * LFA -.0268231*11+1.332656) #Create estimate
Type3$Lower <- with(Type3, Estimate -  1.645 * SE) #create lower bound (90% CI)
Type3$Upper <- with(Type3, Estimate +  1.645 * SE) #create lower bound (90% CI)
head(Type3)
Type3

#Type4 is whole range LFA, LIFA=11, OW_100=1, OW_51=0 and Case2=0
Type4 <- data.frame(
  LIFA=c(11), #LIFA is fixed at (roughly) the mean, to simplify illustration. The influence of LIFA is rather low as shown before.
  LFA=c(1:25),
  SE=c(3.26589,3.110931,2.960008,2.813772,2.672991,
       2.538573,2.411582,2.293252,2.184992,2.088368,
       2.005062,1.936794,1.885199,1.85167,1.837197,
       1.842229,1.866609,1.909595,1.969971,2.046196,
       2.136576,2.239397,2.353029,2.475984,2.606943), #SE is inserted manually as formula is highly complex
  Case=c("OW_100=1, shifting to subs."),
  Case2=c("D"),
  OW=c("OW_100=1"),
  DIR=c("shifting to subsidiary"))
Type4$Estimate <- with(Type4, 9.787941 -.6120982  * LFA -.0268231*11-3.613203) #Create estimate
Type4$Lower <- with(Type4, Estimate -  1.645 * SE) #create lower bound (90% CI)
Type4$Upper <- with(Type4, Estimate +  1.645 * SE) #create lower bound (90% CI)
head(Type4)
Type4

#Type5 is whole range LFA, LIFA=11, OW_100=0, OW_51=1 and Case2=0
Type5 <- data.frame(
  LIFA=c(11), #LIFA is fixed at (roughly) the mean, to simplify illustration. The influence of LIFA is rather low as shown before.
  LFA=c(1:25),
  SE=c(3.519222,3.376,3.237551,3.104513,2.977611,
       2.857663,2.745581,2.642366,2.549094,2.466895,
       2.396907,2.340227,2.297839,2.270545,2.25889,
       2.263118,2.283139,2.318544,2.368644,2.432532,
       2.509153,2.597382,2.696079,2.804138,2.920522), #SE is inserted manually as formula is highly complex
  Case=c("OW_51=1, shifting to subs."),
  Case2=c("E"),
  OW=c("OW_51=1"),
  DIR=c("shifting to subsidiary"))
Type5$Estimate <- with(Type5, 9.787941 -.6120982  * LFA -.0268231*11+.3135587) #Create estimate
Type5$Lower <- with(Type5, Estimate -  1.645 * SE) #create lower bound (90% CI)
Type5$Upper <- with(Type5, Estimate +  1.645 * SE) #create lower bound (90% CI)
head(Type5)
Type5

#Type6 is whole range LFA, LIFA=11, OW_100=0, OW_51=0 and Case2=0
Type6 <- data.frame(
  LIFA=c(11), #LIFA is fixed at (roughly) the mean, to simplify illustration. The influence of LIFA is rather low as shown before.
  LFA=c(1:25),
  SE=c(3.31075,3.141654,2.975033,2.811326,2.651074,
       2.494942,2.343754,2.19853,2.060531,1.931308,
       1.812737,1.70704,1.616743,1.544551,1.493091,
       1.46455,1.460274,1.480471,1.524171,1.589434,
       1.673742,1.77438,1.888741,2.014489,2.149626), #SE is inserted manually as formula is highly complex
  Case=c("OW_51=OW_100=0, shifting to subs."),
  Case2=c("F"),
  OW=c("OW_51=OW_100=0"),
  DIR=c("shifting to subsidiary"))
Type6$Estimate <- with(Type6, 9.787941 -.6120982  * LFA -.0268231*11) #Create estimate
Type6$Lower <- with(Type6, Estimate -  1.645 * SE) #create lower bound (90% CI)
Type6$Upper <- with(Type6, Estimate +  1.645 * SE) #create lower bound (90% CI)
head(Type6)
Type6

COMBO<-rbind(Type1, Type2, Type3, Type4, Type5, Type6)
COMBO

pdf("fig9.pdf", width=6.3, height=3.4,colormodel="cmyk")
ggplot(COMBO,aes(x = LFA, y = Estimate)) +
  geom_segment(aes(x=10.4,xend=18.5,y=0,yend=0),size=1.5, color="gray", alpha=0.5) +
  geom_line(size=0.7,col="blue") +
  geom_hline(yintercept = 0, lty="dashed", color="red", size=0.3) +
  #geom_line(mapping = aes(y = Lower), lty = "dotted", size=0.3) +
  #geom_line(mapping = aes(y = Upper), lty = "dotted", size=0.3) +
  geom_ribbon(aes(ymin=Lower, ymax=Upper), alpha=0.1) + 
  xlab("ln fixed assets") +
  ylab("Semi-elasticity of EBIT w.r.t. tax differential") +
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
  scale_y_continuous(breaks = round(seq(min(-14), max(16), by = 6),1)) +
  facet_wrap(~ Case, nrow=2) +
  theme(strip.text.x = element_text(size = 7,color="black"))
dev.off()
