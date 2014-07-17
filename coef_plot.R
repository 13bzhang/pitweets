cd <- as.data.frame(rbind(lm.gdp, lm.religion, lm.language,
      lm.ally, lm.trade, lm.col, lm.invest))
names(cd) <- c("mean","se")
cd$placebo <- c(rep("C: GDP per Capita",5), 
                rep("D: Likelihood of Being Mostly Christian",5),
                rep("E: Percent of Population Speaks English",5),
                rep("F: Likelihood of Military Alliance with the U.S.*",5), 
                rep("G: Level of Trade with the U.S.*",5), 
                rep("H: Likelihood of Being U.S. Ally in Iraq War**",5),
                rep("I: Level of Investment in U.S. Businesses**",5))
cd$v <- c(rep(c("Basic","Controls","ENE1",
                "ENE2", "Embedded Natural Experiment"),7))
cd$ord <- seq(1:5)
cd$v2 <- factor(cd$v, levels=levels(factor(cd$v)))
cd$v3 <- factor(cd$v, levels=rev(levels(factor(cd$v))))
#cd <- cd[with(cd, order(cd$ord)),]
#cd$v <- factor(cd$v, as.character(cd$v), ordered=T)
# plab <- c("A.1: Countries Mentioned -- Longitude",
#           "A.2: Countries Mentioned -- Latitude",
#           "B.1: Most Plausible Region -- Middle E. and N. Africa",
#           "B.2; Most Plausible Region -- East Asia",
#           "C: GDP per Capita", 
#           "D: Likelihood of Being Mostly Christian",
#           "E: Percent of Population Speaks English",
#           "F: Likelihood of Military Alliance with the U.S.",
#           "G: Trade with the U.S.",
#           "H: Likelihood of Being U.S. Ally in Iraq War",
#           "I: Investment in U.S. Businesses")
f <- ggplot(cd[cd$v!="ENE1" & cd$v!="ENE2",], 
            aes(x=mean,y=v3,shape=v2,color=v2))
f <- f+geom_vline(xintercept=0, linetype="longdash")+
  geom_errorbarh(aes(xmax =  mean + 2.576*se, 
                     xmin = mean - 2.576*se),
                 size=0.6, height=0) +
  geom_errorbarh(aes(xmax =  mean + 1.96*se, 
                     xmin = mean - 1.96*se),
                 size=1.0, height=0)+
  geom_point(stat="identity",size=3.5,fill="white")+
  scale_color_manual(name="Vingette Type",
                     values=c("firebrick3","forestgreen","dodgerblue3"))+
  scale_shape_manual(name="Vingette Type",values=c(21,22,23))
f + facet_wrap( ~ placebo, ncol=1)+
  theme_bb()+
  xlab("Standardized Difference (Dem-NonDem)")+
  ylab("")+scale_y_discrete(breaks=NULL) + 
  ggtitle("Placebo Tests for Confounding")
ggsave("images/coef_plot_main.pdf", height=7, width=5)
f + facet_wrap( ~ placebo, ncol=1)+
  theme_bbtop()+
  xlab("Standardized Difference (Dem-NonDem)")+
  ylab("")+scale_y_discrete(breaks=NULL) + 
  ggtitle("Placebo Tests for Confounding")
ggsave("images/coef_plot_main_top.pdf", height=7, width=5.5)
ggsave("images/coef_plot_main_poster.pdf", height=6, width=12)
