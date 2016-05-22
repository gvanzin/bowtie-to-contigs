setwd("/rsgrps/bhurwitz/scottdaniel/make-custom-patric-metagenome/data")

system("head -1 patric-annotation-for-contigs.tab > header.temp")
system("egrep -v '^prot\s.+' patric-annotation-for-contigs.tab > temp.tab")
system("cat header.temp temp.tab > temp2.tab")
system("mv temp2.tab patric-annotation-for-contigs.tab")

my_annotation = read.delim("patric-annotation-for-contigs.tab",colClasses="character")

my_annotation$prot<-paste('prot',row(my_annotation)[,1],sep = '')

write.table(x = my_annotation,file = "patric-annotation-for-contigs.tab",quote = F,sep = '\t',row.names = F,col.names = F)
