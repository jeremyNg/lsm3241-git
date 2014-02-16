# R script to read and construct flat file for CAMP_SEQ data
# assumes the following file exists::
#camp_seq_species_id.txt
#camp_seq_species_index.txt
#camp_seq_sequence_id.txt
#camp_seq_sequence_index.txt
#camp_seq_length_id.txt
#camp_seq_length_index.txt
#camp_html_links.txt
#camp_html_links_index.txt

# ID all the common IDs first (IDs without missing information)
seq.species <- readLines("~/Desktop/lsm3241-misc/data/camp_SEQ_data_html/curated-CAMP/camp_seq_species_index.txt")
seq.length <- readLines("~/Desktop/lsm3241-misc/data/camp_SEQ_data_html/curated-CAMP/camp_seq_length_index.txt")
seq.sequence <- readLines("~/Desktop/lsm3241-misc/data/camp_SEQ_data_html/curated-CAMP/camp_seq_sequence_index.txt")
# length of seq.species shorter than seq.lenghth, suggesting some samples do not have a species assigned
id.no.species <- seq.length[!seq.length%in%seq.species]
replace.species <- rep(NA,length(id.no.species))
# read in the links id;
ref.index <- readLines("~/Desktop/lsm3241-misc/data/camp_SEQ_data_html/curated-CAMP/camp_html_links_index.txt")
ref.index <- ref.index[grep("CAMP_",ref.index)]
id.no.ref <- seq.length[!seq.length%in%ref.index]
# to read in the remaing data
seq.species.id <- readLines("~/Desktop/lsm3241-misc/data/camp_SEQ_data_html/curated-CAMP/camp_seq_species_id.txt")
seq.length.id <- readLines("~/Desktop/lsm3241-misc/data/camp_SEQ_data_html/curated-CAMP/camp_seq_length_id.txt")
seq.sequence.id <- readLines("~/Desktop/lsm3241-misc/data/camp_SEQ_data_html/curated-CAMP/camp_seq_sequence_id.txt")
seq.references <- readLines("~/Desktop/lsm3241-misc/data/camp_SEQ_data_html/curated-CAMP/camp_html_links.txt")
seq.references <- seq.references[grep("http:",seq.references)]
# to extend the reference file
reference.nil <- rep("None assigned",length(id.no.ref))
# to extend the species list.
seq.species <- c(seq.species,id.no.species)
seq.species.id <- c(seq.species.id,replace.species)
ref.index <- c(ref.index,id.no.ref)
seq.references <- c(seq.references,reference.nil)
# to construct each frame, then perform a merge:
makeflat <- function(){
    df1.species <- data.frame(CAMP_ID=seq.species,Species=seq.species.id)
    df2.length <- data.frame(CAMP_ID=seq.length,Length=seq.length.id)
    df3.sequence <- data.frame(CAMP_ID=seq.sequence,Sequence=seq.sequence.id)
    df4.references <- data.frame(CAMP_ID=ref.index,Link=seq.references)
    flat <- merge(x=df1.species,df2.length,by.x="CAMP_ID",by.y="CAMP_ID")

    flat <- merge(flat,df3.sequence,by.x="CAMP_ID",by.y="CAMP_ID")
    flat <- merge(flat,df4.references,by.x="CAMP_ID",by.y="CAMP_ID")
    return(flat)
    }
camp.flat <- makeflat() # constructs the flat file
camp.flat <- na.omit(camp.flat)
camp.flat$Database <- rep("CAMP",nrow(camp.flat))
setwd("~/Desktop/lsm3241-misc/data/camp_SEQ_data_html/curated-CAMP")
write.table(camp.flat,file="camp_seq_flat.txt",sep="\t") # exports the flatfile!

#END OF THE SCRIPT~

