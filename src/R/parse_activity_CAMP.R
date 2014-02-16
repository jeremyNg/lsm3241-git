# R CMD TO parse temp.txt

init <- readLines("~/Desktop/lsm3241-misc/data/camp_SEQ_data_html/temp.txt") # reads in temp.txt from the initially parsed file
final <- init[grep("Anti",init)]

write.table(final,"~/Desktop/lsm3241-misc/data/camp_SEQ_data_html/temp.txt")

