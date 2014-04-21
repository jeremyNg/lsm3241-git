# script to get NR sequences
# we will use a few filters at a time

# we will do this over multiple coressss

require(multicore)
#x <- read.table("COMBINED.txt",sep="\t") # this is the file we saved
# first we will sort according to the sequences
x <- all
x <- x[order(x$Sequence,decreasing=FALSE),]
# get a list of all the unique sequences
NRsequences <- unique(x$Sequence) # this will form the basis of our NR database
NRsequences <- NRsequences[!is.na(NRsequences)] # this will remove NAs from the list
# heres the script to check for redundancy
# TO DO: Use a divide and conquer (ddply) strategy to speed up this computation maybe?
# PS--> TO vectorize them; now the data is of class factor whcih slows down the lapply computations ...
deredundance <- function(w){
# we do an lapply over the list of sequences
    samesequence <- x[x$Sequence==w,] # these guys have the same sequence
    listofids <-samesequence$Record
    listofids <- listofids[!is.na(listofids)]
    return(listofids) # this is the list of the ID
    }
IDswithsamesequences <- mclapply(NRsequences,deredundance,mc.cores = 3) # this is a list of all the same sequences
#get the sources
deredundant.source<- function(w){
# we do an lapply over the list of sequences
    # to get a list of all the species
    samesequence <- x[x$Sequence==w,] # these guys have the same sequence
    sources <- samesequence$Species[1]
    return(sources) # this is the list of the ID
    }
IDsources <- mclapply(NRsequences,deredundant.source)
NR.data.frame <- data.frame(Sequence=NRsequences)
NR.data.frame$Species <- unlist(IDsources)
IDsfordisplay <- lapply(IDswithsamesequences,function(x){w <- paste0(unlist(as.vector(x)),collapse = ", ")}) # this is a list of ID for display
NR.data.frame$IDs <- unlist(IDsfordisplay)
deredundanceNR <- function(w){
# we do an lapply over the list of sequences
    samesequence <- x[x$Sequence==w,] # these guys have the same sequence
    listofids <-samesequence$NR
    listofids <- listofids[!is.na(listofids)]
    return(listofids) # this is the list of the ID
    }
NRwithsamesequences <- mclapply(NRsequences,deredundanceNR,mc.cores = 3) # this is a
NRsfordisplay <- lapply(NRwithsamesequences,function(x){w <- paste0(unlist(as.vector(x)),collapse = ", ")}) # this is a list of ID for display
NR.data.frame$NR <- unlist(NRsfordisplay)
IDsforfasta <- lapply(IDswithsamesequences,function(x){w <- paste0(unlist(as.vector(x)),collapse = "|")}) # this is a list of ID for display
NR.data.frame$FASTAheader <- unlist(IDsforfasta)
write.table(NR.data.frame,"NR-FASTA.txt",sep="\t") # this exports the NR for FASTA
