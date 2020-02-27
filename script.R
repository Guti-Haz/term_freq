pacman::p_load(randomNames,tm,stringr,parallel,tictoc,pbapply,data.table,magrittr)
names=randomNames(400000)%>%
  str_replace_all("[:punct:]","")%>%
  str_to_lower
res=termFreq(names)
res.dt=data.table(terms=names(res),res=res)
# vector subsetting - base + linux
tic()
score=str_split(names[1:4000]," ")%>%
  pblapply(function(x){sum(res[x])})
toc()
# data.table filter - base + linux
tic()
score=str_split(names," ")%>%
  lapply(function(x){
    res.dt[terms%chin%x,sum(res)]
  })%>%
  lapply(sum)
toc()
