library(ggplot2)
library(viridisLite)
library(viridis)
library(extrafonts)
setwd("~/Desktop/Figures/World Map")
subs_data <- data.frame(
  region=c("Algeria", "Argentina", "Australia","Austria","Belgium",
           "Bermuda", "Bosnia and Herzegovina", "Bulgaria", "Canada", "Spain",
           "Chile", "Costa Rica", "Croatia","Czech Republic",
           "Denmark", "Ecuador", "Estonia", "Finland", "France",
           "Germany", "Greece", "Hong Kong", "Hungary", "Iceland",
           "India", "Indonesia", "Ireland", "Israel", "Italy",
           "Jamaica", "Japan", "Kenya", "Kuwait", "Latvia",
           "Luxembourg", "Macedonia", "Malaysia", "Malta",
           "Montenegro", "Morocco", "Netherlands", "New Zealand", "Nigeria",
           "Norway", "Pakistan", "Philippines", "Poland",
           "Portugal", "South Korea", "Romania", "Serbia", "Singapore",
           "Slovakia", "Slovenia", "South Africa", "Sri Lanka", "Sweden",
           "Thailand", "Ukraine", "United Arab Emirates", "UK",
           "USA", "Uruguay"),
  Subs= c(7,1,1,139,151,
          2,21,48,1,283,
          1,1,30,230,
          102,2,23,70,543,
          703,1,2,87,1,
          71,4,24,1,741,
          1,10,3,1,1,
          12,16,15,2,
          4,10,101,38,2,
          64,3,1,235,
          92,52,173,82,2,
          91,52,1,1,145,
          14,24,1,316,
          2,4
          ))

#WORLD (Figure 2)
map.world <- map_data(map="world")
gg <- ggplot()
gg <- gg + theme(legend.position="none")
gg <- gg + geom_map(data=map.world, map=map.world, aes(map_id=region, x=long, y=lat),
                    fill="grey60")
gg <- gg + coord_equal(ratio=1.3)
gg <- gg + geom_map(data=subs_data, map=map.world, aes(map_id=region, fill=Subs))
gg <- gg + theme_bw()
gg <- gg + theme(legend.position= c(0.07,0.35),legend.key.size = unit(0.6, "cm"),
                 legend.text=element_text(size=6,color="black"),
                 legend.title=element_text(size=6),
                 axis.ticks.length=unit(-0.1, "cm"),
                 axis.ticks = element_line(colour = "black", size = 0.25),
                 axis.text.x = element_text(margin=unit(c(0.15,0,0,0), "cm")),
                 axis.text.y = element_text(margin=unit(c(0,0.15,0,0), "cm")),
                 axis.text=element_text(size=6,color="black"),
                 #axis.ticks=element_blank(),
                 axis.title=element_text(size=6),
                 panel.border = element_rect(colour = "black", fill=NA, size=0.5),
                 )
gg <- gg + theme(plot.margin = unit(c(0,0,0,0), "cm"))
gg <- gg + scale_fill_viridis(trans="log", name= "Number\nof subsi-\ndiaries",
                              breaks = c(3, 10, 25, 75, 250, 500)
                              #,low="blue", high="red"
                              )

pdf("fig2.pdf", width=6, height=3.5,colormodel="cmyk") #for world map
gg
dev.off()

#EUROPE (Figure 14)
map.world <- map_data(map="world")
gg <- ggplot()
gg <- gg + theme(legend.position="none")
gg <- gg + geom_map(data=map.world, map=map.world, aes(map_id=region, x=long, y=lat),
                    fill="grey60")
gg <- gg + coord_equal(ratio=1.3)
gg <- gg + geom_map(data=subs_data, map=map.world, aes(map_id=region, fill=Subs))
gg <- gg + theme_bw()
gg <- gg + theme(legend.position = 'right',legend.key.size = unit(0.5, "cm"),
                 legend.text=element_text(size=6),
                 legend.title=element_text(size=6),
                 axis.ticks.length=unit(-0.1, "cm"),
                 axis.ticks = element_line(colour = "black", size = 0.25),
                 axis.text.x = element_text(margin=unit(c(0.15,0,0,0), "cm")),
                 axis.text.y = element_text(margin=unit(c(0,0.15,0,0), "cm")),
                 axis.text=element_text(size=6,color="black"),
                 axis.title=element_text(size=6),
                 panel.border = element_rect(colour = "black", fill=NA, size=0.5),
                 )
gg <- gg + coord_map("ortho", orientation=c(46, 8, 0),xlim = c(-20, 40),ylim = c(79, 35)) #For european map
gg <- gg + theme(plot.margin = unit(c(0,0,0,0), "cm"))
gg <- gg + scale_fill_viridis(trans="log", name= "Number\nof subsi-\ndiaries",
                               breaks = c(3, 10, 25, 75, 250, 500)
                              #,low="blue", high="red"
                              )

pdf("fig14.pdf", width=3.35, height=2.5,colormodel="cmyk")
gg
dev.off()