pacman::p_load(data.table,magrittr,stringr,textclean,tm)
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
tf=function(dt){
  res=termFreq(dt[,unique(names)])
  temp=data.table(terms=str_to_upper(names(res)),
                  termFreq=res)%>%
    .[,prob:=termFreq/.[,sum(termFreq)]]%>%
    .[,termFreq:=NULL]
  return(temp)
}
dt=readRDS("Names.rds")%>%
  str_split(" ")%>%
  lapply(1:length(.),function(i,l){data.table(terms=l[[i]],names=Names[i])},l=.)%>%
  rbindlist%>%
  .[terms!=""]%>%
  merge(tf(.),by="terms",all.x=T)%>%
  .[!is.na(prob)]%>%
  .[,.(score=prod(prob)),names]
