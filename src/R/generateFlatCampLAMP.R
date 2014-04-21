setwd("../extracted")
files <- list.files()
names <- gsub(".txt","",files)
mapply(function(x,y){w <- read.delim(x,header = F,sep="|");assign(y,w,envir=globalenv());return(NULL)},y=names,x=files) #
rm(files,names)
lapply(ls(),function(x){w <- get(x);dim(w)})
NR <- data.frame(Record=SequenceLengths$V1,NR=sample(1:20000,5547))
reference <- NR$Record

#
> colnames(w)
 [1] "Record"         "NR"             "Name"           "Species"
 [5] "Sequence"       "SequenceLength" "Activity"       "UniProts"
 [9] "PubMed"         "Others"         "URL"
#
x <- NR
colnames(Names) <- c("Record","Name")
x <- merge(x,Names,by="Record")
colnames(Source) <- c("Record","Species")
x <- merge(x,Source,by="Record")
colnames(Sequences) <- c("Record","Sequence")
x <- merge(x,Sequences,by="Record")
colnames(SequenceLengths) <- c("Record","SequenceLength")
x <- merge(x,SequenceLengths,by="Record")

# Activity2
activity2 <- rbind(as.matrix(Activity),as.matrix(data.frame(V1=reference[!reference%in%Activity$V1],V2=NA)))
colnames(activity2) <- c("Record","Activity")
x <- merge(x,activity2,by="Record")

# uniprot
uniprot2 <- rbind(as.matrix(UniProt),as.matrix(data.frame(V1=reference[!reference%in%UniProt$V1],V2=NA)))
colnames(uniprot2) <- c("Record","UniProts")
x <- merge(x,uniprot2,by="Record")

#pubmed
PM2 <- rbind(as.matrix(PubMeds),as.matrix(data.frame(V1=reference[!reference%in%PubMeds$V1],V2=NA)))
colnames(PM2) <- c("Record","PubMed")
x <- merge(x,PM2,by="Record")

#Others
Others <- rbind(as.matrix(Function),as.matrix(data.frame(V1=reference[!reference%in%Function$V1],V2=NA)))
colnames(Others) <- c("Record","Others")
x <- merge(x,Others,by="Record")
x$Record <- gsub(".html","",x$Record)
x$URL <- paste0("http://biotechlab.fudan.edu.cn/database/lamp/detail.php?id=",x$Record)

LAMP <- x

