#library(ggplot2)
#library(gridExtra)
#library(dplyr)
#library(RColorBrewer)

require(plyr)

filenames <- list.files("kaks", pattern="*.tab", full.names=TRUE)
pdf("plot/ks_6max.pdf",width=15,height=15)
par(mfrow=c(3,3))

for (i in seq_along(filenames)) {
 # print(filenames[i])
  short = gsub(".yn00.tab","",filenames[i])
  shortname = substr(short,6,40)
  
  #print(shortname)
  n <- read.table(file=filenames[i],header=TRUE,sep="\t")

  prune_dS <- subset(n$dS,n$dS < 6)
                                        #summ = summary(n$dS)
                                        #print(summ)
  if ( length(prune_dS) > 50 ) { # make sure at least 10 paralog pairs
    summ = summary(prune_dS)
   # print(summ)
    lbl = sprintf("%s",shortname)
    hist(prune_dS,50,main=lbl)
  }
}


pdf("plot/ks_2max.pdf",width=15,height=15)
par(mfrow=c(3,3))

for (i in seq_along(filenames)) {
 # print(filenames[i])
  short = gsub(".yn00.tab","",filenames[i])
  shortname = substr(short,6,40)
  
  n <- read.table(file=filenames[i],header=TRUE,sep="\t")
  prune_dS <- subset(n$dS,n$dS < 2)
                                        #summ = summary(n$dS)
                                        #print(summ)
  if ( length(prune_dS) > 50 ) { # make sure at least 10 paralog pairs
    summ = summary(prune_dS)
#    print(summ)
    lbl = sprintf("%s",shortname)
    hist(prune_dS,50,main=lbl)
  }
}
