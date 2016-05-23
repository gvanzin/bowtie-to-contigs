setwd("/rsgrps/bhurwitz/scottdaniel/make-small-patric/data")

my_annotation = read.delim("patric-annotation-for-contigs.tab",colClasses="character")

my_annotation$prot<-paste('prot',row(my_annotation)[,1],sep = '')

write.table(x = my_annotation,file = "patric-annotation-for-contigs.tab",quote = F,sep = '\t',row.names = F,col.names = T)
