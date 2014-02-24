#############################################################################
# TO DO::
#############################################################################


# ID all the common IDs first (IDs without missing information)
##############################################
# CHUNK For CAMP
# R script to read and construct flat file for CAMP database
# assumes the following file exists::
# camp_seq_species_id.txt
# camp_seq_species_index.txt
# camp_seq_sequence_id.txt
# camp_seq_sequence_index.txt
# camp_seq_length_id.txt
# camp_seq_length_index.txt
# camp_html_links.txt
# camp_html_links_index.txt
# activity.txt
# activityindex.txt

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
# CAMP activity index
activity.in <- readLines("~/Desktop/lsm3241-misc/data/camp_SEQ_data_html/curated-CAMP/activityindex.txt")
activity <- readLines("~/Desktop/lsm3241-misc/data/camp_SEQ_data_html/curated-CAMP/activity.txt")
id.no.activity <- seq.length[!seq.length%in%activity.in]
activity.uk <- rep("Not listed",length(id.no.activity))

camp.activity.ind <- c(activity.in,id.no.activity)
camp.activity <- c(activity,activity.uk)

# to extend the species list.
seq.species <- c(seq.species,id.no.species)
seq.species.id <- c(seq.species.id,replace.species)
# to construct each frame, then perform a merge:
makeflat <- function(){
    df1.species <- data.frame(CAMP_ID=seq.species,Species=seq.species.id)
    df2.length <- data.frame(CAMP_ID=seq.length,Length=seq.length.id)
    df3.sequence <- data.frame(CAMP_ID=seq.sequence,Sequence=seq.sequence.id)
    df4.activity <- data.frame(CAMP_ID=camp.activity.ind,Activity=camp.activity)
    flat <- merge(x=df1.species,df2.length,by.x="CAMP_ID",by.y="CAMP_ID")
    flat <- merge(flat,df3.sequence,by.x="CAMP_ID",by.y="CAMP_ID")
    flat <- merge(flat,df4.activity,by.x="CAMP_ID",by.y="CAMP_ID")
    return(flat)
    }
camp.flat <- makeflat() # constructs the flat file
camp.flat <- na.omit(camp.flat)
camp.flat$Source <- rep("CAMP",nrow(camp.flat))
colnames(camp.flat)[1]<- "ID"
write.table(camp.flat,file="~/Desktop/lsm3241-misc/data/camp_SEQ_data_html/curated-CAMP/camp_seq_flat.txt",sep="\t") # exports the flatfile!
###########################################################

###########################################################
# Chunk for LAMP
# R script to read and construct flat file for CAMP database
# assumes the following file exists::
# index.txt
# sequences.txt
# species.txt
# sequencelength.txt
# activity.txt

LAMPid <- readLines("~/Desktop/lsm3241-misc/data/LAMP_html/curated-LAMP/index.txt")
LAMPsequence <- readLines("~/Desktop/lsm3241-misc/data/LAMP_html/curated-LAMP/sequences.txt")
LAMPspecies <- readLines("~/Desktop/lsm3241-misc/data/LAMP_html/curated-LAMP/species.txt")
LAMPlengths <- readLines("~/Desktop/lsm3241-misc/data/LAMP_html/curated-LAMP/sequencelength.txt")
LAMPactivity <- readLines("~/Desktop/lsm3241-misc/data/LAMP_html/curated-LAMP/activity.txt")
LAMPsequence <- LAMPsequence[-grep(".html",LAMPsequence)]
LAMPlengths <- LAMPlengths[-grep(".html",LAMPlengths)]

# to build the DF to make the flatfile
lamp.flat <- data.frame(ID=LAMPid, Species=LAMPspecies,Length=LAMPlengths,Sequence=LAMPsequence, Activity=LAMPactivity)
lamp.flat$Source <- rep("LAMP",nrow(lamp.flat))
write.table(lamp.flat,file="~/Desktop/lsm3241-misc/data/LAMP_html/curated-LAMP/lamp_flat.txt",sep="\t")

# to merge flatfiles, since the sequence are the same already
mergedFF <- rbind(camp.flat,lamp.flat)

write.table(mergedFF,file="/Users/Jeremy/Desktop/lsm3241-misc/data/consolidated/merged.txt",sep="\t")

#END OF THE SCRIPT~

