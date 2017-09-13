setwd("~/Desktop/Figures/Semi-elasticities")
library(fields)
library(maps)
library(viridisLite)
library(viridis)

#ME PLOT 3D
###########
#This plot is drawn using data from Regression (1) in Table 8
#f is the marginal effect in Regression (1) of Table 8, the marginal effect is evaluated at
#the complete range of LFA and LIFA for wholly-owned subs with shifting direction to the parent
#i.e. OW_100=1 and Case2=1
f <- function(x, y){9.787941-.6120982*x-.0268231*y-3.613203+1.332656} # x is LFA, y is LIFA
x <- 1 #minimum value of LFA
xmax <- 25 #maximum value of LFA
y <- -5 #minimum value of LIFA
ymax <- 24 #maximum value of LIFA

z<-outer(x:xmax, y:ymax, f)
z

#4 plots

par(mfrow=c(2,2),  mai = c(0.6, 0, 0, 0))
persp(seq(1, 25, 1), seq(-5, 24, 1), z, phi = 0, theta = 45,
      xlab = "ln fixed assets", ylab = "ln intangible fixed assets", zlab ="Marginal effect",
      axes=T, ticktype="detailed", nticks=8, shade=0.2)

persp(seq(1, 25, 1), seq(-5, 24, 1), z, phi = 45, theta = 45,
      xlab = "ln fixed assets", ylab = "ln intangible fixed assets", zlab ="Marginal effect",
      axes=T, ticktype="detailed", nticks=8, shade=0.2)

persp(seq(1, 25, 1), seq(-5, 24, 1), z, phi = 0, theta = 20,
      xlab = "ln fixed assets", ylab = "ln intangible fixed assets", zlab ="Marginal effect",
      axes=T, ticktype="detailed", nticks=8, shade=0.2)

persp(seq(1, 25, 1), seq(-5, 24, 1), z, phi = 0, theta = 110,
      xlab = "ln fixed assets", ylab = "ln intangible fixed assets", zlab ="Marginal effect",
      axes=T, ticktype="detailed", nticks=8, shade=0.2)


#2 plots

pdf("fig8.pdf", width=10, height=5,colormodel="cmyk")
par(mfrow=c(1,2),  mar = c(1,1,0,4))
drape.plot(seq(1, 25, 1), seq(-5, 24, 1), z, phi = 0, theta = 60,
      xlab = "ln fixed assets", ylab = "ln intangible fixed assets", zlab ="Marginal effect",
      axes=T, nticks=8,col=rainbow(50),border=NA,horizontal=FALSE)

drape.plot(seq(1, 25, 1), seq(-5, 24, 1), z, phi = 0, theta = 120,
      xlab = "ln fixed assets", ylab = "ln intangible fixed assets", zlab =" ",
      axes=T, nticks=8, col=rainbow(50),border=NA,horizontal=FALSE)
dev.off()