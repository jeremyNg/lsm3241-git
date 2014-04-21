# R script to generate flatfile in APD

setwd("extracted") # to change directory
files <- gsub(".txt","",list.files()) # list the files
filenames <- list.files() # list the files
mapply(function(x,y){w <- read.delim(x,header = F,sep="|");assign(y,w,envir=globalenv());return(NULL)},x=filenames,y=files) # reads in the files using mapply


# Record,NR,Name,Species,Sequence,Length,Activity,Unipro,PubMeds,Others,URL
NR<- data.frame(Record=SequenceLength$V1,NR=sprintf("NR%07d",sample(1:100000,nrow(SequenceLength),replace = F)))
#merge in the names
colnames(Names) <- c("Record","Name")
APD <- merge(NR,Names,by="Record")
reference <- NR$Record
# species and sequence  data
colnames(Species) <- c("Record","Species")
APD <- merge(APD,Species,by="Record")
colnames(Sequences) <- c("Record","Sequence")
APD <- merge(APD,Sequences,by="Record")
colnames(SequenceLength) <- c("Record","SequenceLength")
APD <- merge(APD,SequenceLength,by="Record")

# activity data
colnames(activity) <- c("Record","Activity")
APD <- merge(APD,activity,by="Record")

# Uniprot
colnames(UniProt) <- c("Record","UniProts")
UniProt2 <- rbind(UniProt,data.frame(Record=reference[!reference%in%UniProt$Record],UniProts=NA))
APD <- merge(APD,UniProt2,by="Record")

# Uniprot
colnames(PubMeds) <- c("Record","PubMeds")
PubMeds2 <- rbind(PubMeds,data.frame(Record=reference[!reference%in%PubMeds$Record],PubMeds=NA))
APD <- merge(APD,PubMeds2,by="Record")

# Others
colnames(AdditionalInfo) <- c("Record","Others")
Others2 <- rbind(AdditionalInfo,data.frame(Record=reference[!reference%in%AdditionalInfo$Record],Others=NA))
APD <- merge(APD,Others2,by="Record")
APD$Record <- gsub(".html","",APD$Record)
APD$URL <- paste0("http://aps.unmc.edu/AP/database/query_output.php?ID=APD_",gsub("APD_","",APD$Record))

write.table(APD,"APD_flatfile.txt",sep="\t")
