# R script to make flat file for CAMP SEQ database

setwd("camp_SEQ_data_html/extracted") # changes the working directory
files <- gsub(".txt","",list.files()) # list the files
filenames <- list.files() # list the files
mapply(function(x,y){w <- read.delim(x,header = F,sep="|");assign(y,w,envir=globalenv());return(NULL)},x=filenames,y=files) # reads in the files using mapply
lapply(ls(),function(x){w <- get(x);dim(w)}) # checks the dimensions, which indicate the number of records
rm(files,filenames)
# to find out which samples do not have certain information, and then add an NA record for them
reference <- campName$V1
ls()[!ls()%in%"references"][which(unlist(lapply(ls()[!ls()%in%"reference"],function(x){w <- get(x);nrow(w)}))!=length(reference))] # flag out data which does not have the same number of records as the reference

# activity file
Activity2 <- rbind(as.matrix(Activity),as.matrix(data.frame(V1=reference[!reference%in%Activity$V1],V2=NA))) # creates a new dataframe of equal dimensions
dim(Activity2)
Activity2 <- as.data.frame(Activity2)
Activity2 <- Activity2[order(Activity2$V1),] #performs a sorting for merging later
colnames(Activity2) <- c("Record","Activity") #sets the column names

# geninfo file
GenInfo2 <- rbind(as.matrix(GenInfo),as.matrix(data.frame(V1=reference[!reference%in%GenInfo$V1],V2=NA)))
dim(GenInfo2)
GenInfo2 <- as.data.frame(GenInfo2)
GenInfo2 <- GenInfo[order(GenInfo2$V1),] # orders for merging
colnames(GenInfo2) <- c("Record","GenInfo") # sets the colnames

# NCBI taxonomy
NCBItaxonomy2 <- rbind(as.matrix(NCBItaxonomy),as.matrix(data.frame(V1=reference[!reference%in%NCBItaxonomy$V1],V2=NA)))
dim(NCBItaxonomy2)
NCBItaxonomy2 <- as.data.frame(NCBItaxonomy2)
NCBItaxonomy2 <- NCBItaxonomy[order(NCBItaxonomy2$V1),] # orders for merging
colnames(NCBItaxonomy2) <- c("Record","NCBItaxonomy") # sets the colnames

# PubMed
PubMeds2 <- rbind(as.matrix(PubMeds),as.matrix(data.frame(V1=reference[!reference%in%PubMeds$V1],V2=NA)))
dim(PubMeds2)
colnames(PubMeds2) <- c("Record","PubMeds") # sets the colnames
PubMeds2 <- as.data.frame(PubMeds2)
PubMeds2 <- PubMeds2[order(PubMeds2$Record),] # orders for merging

# Species
Species2 <- rbind(as.matrix(Species),as.matrix(data.frame(V1=reference[!reference%in%Species$V1],V2=NA)))
colnames(Species2) <- c("Record","Species") # sets the colnames
Species2 <- as.data.frame(Species2)
Species2 <- Species2[order(Species2$Record),] # orders for merging
dim(Species2)

# UniProt
UniProts2 <- rbind(as.matrix(UniProts),as.matrix(data.frame(V1=reference[!reference%in%UniProts$V1],V2=NA)))
colnames(UniProts2) <- c("Record","UniProts") # sets the colnames
UniProts2 <- as.data.frame(UniProts2)
UniProts2 <- UniProts2[order(UniProts2$Record),] # orders for merging
dim(UniProts2)

# Validation
Validation2 <- rbind(as.matrix(Validation),as.matrix(data.frame(V1=reference[!reference%in%Validation$V1],V2=NA)))
colnames(Validation2) <- c("Record","Validation") # sets the colnames
Validation2 <- as.data.frame(Validation2)
Validation2 <- Validation2[order(Validation2$Record),] # orders for merging
dim(Validation2)

# sequence
Sequence2 <- rbind(sequences,data.frame(V1=reference[!reference%in%sequences$V1],V2=NA))
colnames(Sequence2) <- c("Record","Sequence") # sets the colnames
Sequence2 <- as.data.frame(Sequence2)
Sequence2 <- Sequence2[order(Sequence2$Record),] # orders for merging
dim(Sequence2)

# sequence Length
SequenceLength2 <- rbind(sequenceLengths,data.frame(V1=reference[!reference%in%sequenceLengths$V1],V2=NA))
colnames(SequenceLength2) <- c("Record","SequenceLength") # sets the colnames
SequenceLength2 <- as.data.frame(SequenceLength2)
SequenceLength2 <- SequenceLength2[order(SequenceLength2$Record),] # orders for merging
dim(SequenceLength2)
colnames(campName) <- c("Record","Name")

# Other records
Others <- merge(GenInfo2,Validation2,by="Record")
Others2 <- data.frame(Record=Others$Record,Others=paste0("GenInfo (NCBI): <a href=ncbi.nlm.nih.gov/protein",Others$GenInfo,">",Others$GenInfo,"</a><br>Validation Status:",Others$Validation,"<br>"))
Others2 <- rbind(as.matrix(Others2),as.matrix(data.frame(Record=reference[!reference%in%Others2$Record],Others=NA)))
Others2 <- as.data.frame(Others2)

NR <- data.frame(Record=campName$Record,NR=sprintf("NR%05d",sample(1:10000,nrow(campName))))

x <- merge(NR,campName,by="Record") # first merge
x <- merge(x,Species2,by="Record") # add species information
x <- merge(x,Sequence2,by="Record") # add sequence information
x <- merge(x,SequenceLength2,by="Record") # add sequence information
x <- merge(x,Activity2,by="Record")
x <- merge(x,UniProts2,by="Record")
x <- merge(x,PubMeds2,by="Record")
x <- merge(x,Others2,by="Record")
x$Record <- gsub("CAMP_SEQ","CAMPSQ",x$Record)
x$Record <- gsub(".html","",x$Record)
x$URL <-paste0("http://www.camp.bicnirrh.res.in/seqDisp.php?id=",x$Record)

CAMPSEQ <- x # reassign name


write.table(CAMPSEQ,file="CAMPSEQflat.txt",sep="\t") # exports the file as a "\t" file
rm(list=ls()[!ls()%in%"CAMPSEQ"]) # flushes the workspace

save.image(file="Workspace_flatfiles.RData") # exports the workspace as an RData file for easy working in future

