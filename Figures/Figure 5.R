library(ggplot2)
library(directlabels)
library(plyr)
library(grid)
library(gridExtra)
library(viridisLite)
library(viridis)

setwd("~/Desktop/Figures/World Map")
TR_DATA = read.csv("Tax Rates CSV.csv", header = TRUE, stringsAsFactors=FALSE)
head(TR_DATA)

d<-TR_DATA[(TR_DATA$Year==2015 & TR_DATA$UN_Broad=="Europe" & TR_DATA$TaxDiff>0),]

#This is Figure 5

subs_data <- data.frame(
  region=c("Austria", "Belgium", "Czech Republic", "Germany", "Denmark",
           "Estonia", "Spain", "Finland", "France", "UK",
           "Greece", "Croatia", "Hungary", "Iceland", "Italy",
           "Luxembourg", "Malta", "Netherlands", "Norway", "Poland",
           "Portugal", "Sweden", "Slovakia", "Ukraine"),
  Tax=d$TaxDiff)



#EUROPE Shifting Incentive to Switzerland
map.world <- map_data(map="world")
gg <- ggplot()
gg <- gg + theme(legend.position="none")
gg <- gg + geom_map(data=map.world, map=map.world, aes(map_id=region, x=long, y=lat),
                    fill="grey60")
gg <- gg + coord_equal(ratio=1.3)
gg <- gg + geom_map(data=subs_data, map=map.world, aes(map_id=region, fill=Tax))
gg <- gg + theme_bw()
gg <- gg + theme(legend.position = 'right',legend.key.size = unit(0.4, "cm"),
                 legend.text=element_text(size=6),
                 legend.title=element_text(size=6),
                 axis.ticks.length=unit(-0.1, "cm"),
                 axis.ticks = element_line(colour = "black", size = 0.25),
                 axis.text.x = element_text(margin=unit(c(0.15,0,0,0), "cm")),
                 axis.text.y = element_text(margin=unit(c(0,0.15,0,0), "cm")),
                 axis.text=element_text(size=6,color="black"),
                 axis.title=element_text(size=6),
                 panel.border = element_rect(colour = "black", fill=NA, size=0.5),
                 plot.title = element_text(size = 6))
gg <- gg + coord_map("ortho", orientation=c(46, 8, 0),xlim = c(-20, 40),ylim = c(79, 35)) #For european map
gg <- gg + theme(plot.margin = unit(c(0,0,0,0), "cm"))
gg1 <- gg + scale_fill_viridis(name= "Size of tax\ndifferential",
                              breaks = c(0, 0.05, 0.1, 0.15, 0.2)
                              #,low="blue",high="red"
                              )



f<-TR_DATA[(TR_DATA$Year==2015 & TR_DATA$UN_Broad=="Europe" & TR_DATA$TaxDiff<0),]

subs_data2 <- data.frame(
  region=c("Bosnia and Herzegovina", "Bulgaria", "Ireland", "Latvia", "Montenegro",
           "Macedonia", "Romania", "Serbia", "Slovenia"),
  Tax2=f$TaxDiff)

#EUROPE Shifting Incentive out of Switzerland
map.world <- map_data(map="world")
gg <- ggplot()
gg <- gg + theme(legend.position="none")
gg <- gg + geom_map(data=map.world, map=map.world, aes(map_id=region, x=long, y=lat),
                    fill="grey60")
gg <- gg + coord_equal(ratio=1.3)
gg <- gg + geom_map(data=subs_data2, map=map.world, aes(map_id=region, fill=Tax2))
gg <- gg + theme_bw()
gg <- gg + theme(legend.position = 'right',legend.key.size = unit(0.4, "cm"),
                 legend.text=element_text(size=6),
                 legend.title=element_text(size=6),
                 axis.ticks.length=unit(-0.1, "cm"),
                 axis.ticks = element_line(colour = "black", size = 0.25),
                 axis.text.x = element_text(margin=unit(c(0.15,0,0,0), "cm")),
                 axis.text.y = element_text(margin=unit(c(0,0.15,0,0), "cm")),
                 axis.text=element_text(size=6,color="black"),
                 axis.title=element_text(size=6),
                 panel.border = element_rect(colour = "black", fill=NA, size=0.5),
                 plot.title = element_text(size = 6))
gg <- gg + coord_map("ortho", orientation=c(46, 8, 0),xlim = c(-20, 40),ylim = c(79, 35)) #For european map
gg <- gg + theme(plot.margin = unit(c(0,0,0,0), "cm"))
gg2 <- gg + scale_fill_viridis(name= "Size of tax\ndifferential",
                                breaks = c(-0.08, -0.04, 0)
                                #,low="blue",high="red"
                                )

#Put plots together and save as pdf
pdf("fig5.pdf", width=5.7, height=2,colormodel="cmyk")
grid.arrange(gg1, gg2, ncol=2)
dev.off()