# summary results:
cd <- as.data.frame(matrix(NA,3,3))
names(cd) <- c("mean","se","measure")
cd$mean <- c(4,2,3)
cd$se <- c(2,1,2)
cd$measure <- as.factor(c("C1","C2","C3"))
cd$revmeasure <- factor(cd$measure, levels=rev(levels(factor(cd$measure))))
# make the graph
library(ggplot2)
f <- ggplot(cd, 
            aes(x=mean,y=revmeasure,shape=measure,color=measure))
f <- f+geom_vline(xintercept=0, linetype="longdash")+
  geom_errorbarh(aes(xmax =  mean + 2.576*se, #99 confidence interval
                     xmin = mean - 2.576*se),
                 size=0.6, height=0) +
  geom_errorbarh(aes(xmax =  mean + 1.96*se, #95 confience interval
                     xmin = mean - 1.96*se),
                 size=1.0, height=0)+
  geom_point(stat="identity",size=3.5,fill="white")+
  scale_color_manual(name="Experiment Type",
                     values=c("firebrick3","forestgreen","dodgerblue3"))+
  scale_shape_manual(name="Experiment Type",values=c(21,22,23))+
  xlab("Coeffient")+ylab("")


