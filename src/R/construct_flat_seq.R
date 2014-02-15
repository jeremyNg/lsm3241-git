# R script to read and construct flat file for CAMP_SEQ data
# assumes the following file exists::
#camp_seq_species_id.txt
#camp_seq_species_index.txt
#camp_seq_sequence_id.txt
#camp_seq_sequence_index.txt
#camp_seq_length_id.txt
#camp_seq_length_index.txt

# ID all the common IDs first (IDs without missing information)
seq.species <- readLines("camp_seq_species_index.txt")
seq.length <- readLines("camp_seq_length_index.txt")
seq.sequence <- readLines("camp_seq_sequence_index.txt")
# length of seq.species shorter than seq.lenghth, suggesting some samples do not have a species assigned
id.no.species <- seq.length[!seq.length%in%seq.species]
replace.species <- rep(NA,length(id.no.species))

# to read in the remaing data
seq.species.id <- readLines("camp_seq_species_id.txt")
seq.length.id <- readLines("camp_seq_length_id.txt")
seq.sequence.id <- readLines("camp_seq_sequence_id.txt")
# to extend the species list.
seq.species <- c(seq.species,id.no.species)
seq.species.id <- c(seq.species.id,replace.species)

# to construct each frame, then perform a merge:
makeflat <- function(){
    df1.species <- data.frame(CAMP_ID=seq.species,Species=seq.species.id)
    df2.length <- data.frame(CAMP_ID=seq.length,Length=seq.length.id)
    df3.sequence <- data.frame(CAMP_ID=seq.sequence,Sequence=seq.sequence.id)
    flat <- merge(x=df1.species,df2.length,by.x="CAMP_ID",by.y="CAMP_ID")
    print(colnames(flat))
    flat <- merge(flat,df3.sequence,by.x="CAMP_ID",by.y="CAMP_ID")
    return(flat)
    }
camp.flat <- makeflat() # constructs the flat file
camp.flat <- na.omit(camp.flat)
write.table(camp.flat,file="camp_seq_flat.txt",sep="\t") # exports the flatfile!

#END OF THE SCRIPT~
