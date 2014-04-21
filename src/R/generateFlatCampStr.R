# R script to make flat file for CAMP STR database

files <- gsub(".txt","",list.files()) # list the files
filenames <- list.files() # list the files
mapply(function(x,y){w <- read.delim(x,header = F,sep="|");assign(y,w,envir=globalenv());return(NULL)},x=filenames,y=files) # reads in the files using mapply
lapply(ls(),function(x){w <- get(x);dim(w)}) # checks the dimensions, which indicate the number of records
rm(files,filenames)
# to find out which samples do not have certain information, and then add an NA record for them
reference <- Sequences$V1
ls()[!ls()%in%"references"][which(unlist(lapply(ls()[!ls()%in%c("CAMPSEQ","reference")],function(x){w <- get(x);nrow(w)}))!=length(reference))] # flag out data which does not have the same number of records as the reference

# activity file
Activity2 <- rbind(as.matrix(Activity),as.matrix(data.frame(V1=reference[!reference%in%Activity$V1],V2=NA))) # creates a new dataframe of equal dimensions
dim(Activity2)
Activity2 <- as.data.frame(Activity2)
Activity2 <- Activity2[order(Activity2$V1),] #performs a sorting for merging later
colnames(Activity2) <- c("Record","Activity") #sets the column names

#PDB file
PDBs2 <- rbind(as.matrix(PDBs),as.matrix(data.frame(V1=reference[!reference%in%Activity$V1],V2=NA))) # creates a new dataframe of equal dimensions
dim(PDBs2)
PDBs2 <- as.data.frame(PDBs2)
PDBs2 <- PDBs2[order(PDBs2$V1),] #performs a sorting for merging later
colnames(PDBs2) <- c("Record","PDB") #sets the column names

# PubMed file
PubMeds2 <- rbind(PubMeds,data.frame(V1=reference[!reference%in%PubMeds$V1],V2=NA)) # creates a new dataframe of equal dimensions
dim(PubMeds2)
PubMeds2 <- as.data.frame(PubMeds2)
PubMeds2 <- PubMeds2[order(PubMeds2$V1),] #performs a sorting for merging later
colnames(PubMeds2) <- c("Record","PubMed") #sets the column names

colnames(Sequences) <- c("Record","Sequence") #sets the column names

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

colnames(sequenceLengths) <- c("Record","SequenceLength")
ref.pool <-sprintf("NR%05d",1:100000)
ref.o <- ref.pool[!ref.pool%in%CAMPSrm(AMPsEQ$NR]
NR <- data.frame(Record=UniProts2$Record,NR=sample(ref.o,nrow(UniProts2)))
colnames(Validation) <- c("Record","Structural determinationa")
colnames(PDBs) <- c("Record","PDB")
Others <- merge(PDBs,Validation,by="Record")
 # to merge into a flatfile
Others2 <- data.frame(Record=Others$Record, Others=paste0("<a href=http://www.rcsb.org/pdb/explore/explore.do?structureId=\"",Others$PDBa,"\">",Others$PDBa,"</a><br>","Determined by ",Others$Validation))
x <- NR
x$Name <- NA
x <- merge(x,Species2,by="Record")
x <- merge(x,Sequences,by="Record")
x <- merge(x,sequenceLengths,by="Record")
x <- merge(x,Activity2,by="Record")
x <- x[-609,] # there is a duplicate entry at row 609
x <- merge(x,UniProts2,by="Record")
x <- merge(x,PubMeds2,by="Record")
x <- merge(x,Others2,by="Record")
x$Record <- gsub(".html","",x$Record)
x$Record <- gsub("camp_STR","CAMPST",x$Record)
x$URL <- paste0("http://www.camp.bicnirrh.res.in/jmol/strDisp.php?id=",x$Record)
CAMPSTR <- x # reassign to CAMPSTR
write.table(CAMPSTR,sep="\t",file="CAMPSTR.txt") # writes out the file.exists

