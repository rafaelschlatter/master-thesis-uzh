library(ggplot2)
library(directlabels)
library(plyr)
setwd("~/Desktop/Figures/Tax Rate Graphs")
TR_DATA = read.csv("Tax Rates CSV.csv", header = TRUE, stringsAsFactors=FALSE)
head(TR_DATA)

#generate dataframe with Swiss tax rate
Swiss<-data.frame(TaxRate=c(0.2063,0.1920,0.1896,0.1875,0.1831,
                            0.1806,0.1801,0.1792,0.1792),
                  Year=c(2007,2008,2009,2010,2011,
                         2012,2013,2014,2015),
                  UN_Broad=c("Europe"),
                  UN_Detailed=c("Western Europe"))

#UN_Broad plot (This is Figure 3)
pdf("fig3.pdf",width=6, height=1.8,colormodel="cmyk")
ggplot(TR_DATA, aes(x = Year, y = UN_B_mean_TR, group = UN_Broad)) +
  geom_line(col="blue",size=0.7) +
  geom_line(mapping = aes(y = UN_B_max_TR), lty = "dashed", col="black", size=0.3) +
  geom_line(mapping = aes(y = UN_B_min_TR), lty = "dashed", col="black", size=0.3) +
  geom_ribbon(aes(ymin=UN_B_Lower, ymax=UN_B_Upper), alpha=0.1) +
  geom_line(data=Swiss, aes(x = Year, y = TaxRate), size=0.3,col="red") +
  #geom_point(data=Swiss, aes(x = Year, y = TaxRate), size=1, shape=21, fill="white",col="blue") +
  scale_y_continuous(breaks = seq(0, 2, .1)) +
  xlab("Year") +
  ylab("Statutory tax rate") +
  facet_wrap(~ UN_Broad, nrow=1) +
  theme_bw()+
  theme(legend.position="none",
        axis.text=element_text(size=6,color="black"),
        axis.title=element_text(size=7),
        axis.ticks.length=unit(-0.1, "cm"),
        axis.ticks = element_line(colour = "black", size = 0.25),
        axis.text.x = element_text(margin=unit(c(0.15,0,0,0), "cm"),angle=0, hjust=0.5),
        axis.text.y = element_text(margin=unit(c(0,0.15,0,0), "cm")),
        element_line(colour = "light grey",size=0.1),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_rect(colour = "black", fill=NA, size=0.5),
        strip.background = element_rect(colour = "black",
                                        fill = "wheat1")) +
  theme(strip.text.x = element_text(size = 7,color="black"))
dev.off()

#UN_Detailed Europe plot (This is Figure 4)
pdf("fig4.pdf",width=5.5, height=1.8,colormodel="cmyk")
ggplot(data=subset(TR_DATA, UN_Detailed %in% c("Western Europe", "Eastern Europe", "Northern Europe", "Southern Europe")), aes(x = Year, y = UN_D_mean_TR, group = UN_Detailed)) +
  geom_line(size=0.7, col="blue") +
  geom_line(mapping = aes(y = UN_D_max_TR), lty = "dashed", size=0.3) +
  geom_line(mapping = aes(y = UN_D_min_TR), lty = "dashed", size=0.3) +
  geom_ribbon(aes(ymin=UN_D_Lower, ymax=UN_D_Upper), alpha=0.1) +
  geom_line(data=Swiss, aes(x = Year, y = TaxRate), size=0.3,col="red") +
  #geom_point(data=Swiss, aes(x = Year, y = TaxRate), size=1, shape=21, fill="white",col="blue") +
  scale_y_continuous(breaks = seq(0, 1, .05)) +
  xlab("Year") +
  ylab("Statutory tax rate") +
  facet_wrap(~ UN_Detailed, nrow=1) +
  theme_bw()+
  theme(legend.position="none",
        axis.text=element_text(size=6,color="black"),
        axis.title=element_text(size=7),
        axis.ticks.length=unit(-0.1, "cm"),
        axis.ticks = element_line(colour = "black", size = 0.25),
        axis.text.x = element_text(margin=unit(c(0.15,0,0,0), "cm"),angle=0, hjust=0.5),
        axis.text.y = element_text(margin=unit(c(0,0.15,0,0), "cm")),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank(),
        panel.border = element_rect(colour = "black", fill=NA, size=0.5),
        element_line(colour = "light grey",size=0.1),
        strip.background = element_rect(colour = "black", fill = "wheat1")) +
  theme(strip.text.x = element_text(size = 7,color="black"))
dev.off()

#UN_Detailed plot (this is Figure 15)
pdf("fig15.pdf",width=6, height=7,colormodel="cmyk")
ggplot(TR_DATA, aes(x = Year, y = UN_D_mean_TR, group = UN_Detailed)) +
  geom_line(size=0.7,col="blue") +
  geom_line(mapping = aes(y = UN_D_max_TR), lty = "dashed", size=0.3) +
  geom_line(mapping = aes(y = UN_D_min_TR), lty = "dashed", size=0.3) +
  geom_ribbon(aes(ymin=UN_D_Lower, ymax=UN_D_Upper), alpha=0.1) +
  geom_line(data=Swiss, aes(x = Year, y = TaxRate), size=0.3,col="red") +
  #geom_point(data=Swiss, aes(x = Year, y = TaxRate), size=1, shape=21, fill="white") +
  xlab("Year") +
  ylab("Statutory tax rate") +
  facet_wrap(UN_Broad ~ UN_Detailed,ncol=4) +
  theme_bw()+
  theme(legend.position="none",
        axis.text=element_text(size=6,color="black"),
        axis.title=element_text(size=7),
        axis.ticks.length=unit(-0.1, "cm"),
        axis.ticks = element_line(colour = "black", size = 0.25),
        axis.text.x = element_text(margin=unit(c(0.15,0,0,0), "cm"),angle=0, hjust=0.5),
        axis.text.y = element_text(margin=unit(c(0,0.15,0,0), "cm")),
        #axis.text.x = element_text(angle=90, hjust=1),
        panel.grid.minor = element_blank(),
        panel.grid.major =element_blank(),
        panel.border = element_rect(colour = "black", fill=NA, size=0.5),
        element_line(colour = "light grey",size=0.1),
        strip.background = element_rect(colour = "black", fill = "wheat1")) +
  theme(strip.text.x = element_text(size = 7,color="black")) 
dev.off()