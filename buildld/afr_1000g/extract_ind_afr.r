info_pop<-read.csv('superPop.info', sep='\t', header=F)
info_ind<-read.csv('20130606_g1k.ped', sep='\t', header=T)

info_pop<-info_pop[,1:3];names(info_pop)<-c('Population', 'Description', 'SuperPop')
info_ind<-merge(info_ind,info_pop,all=F, by='Population')
info_ind_afr<-info_ind[info_ind$SuperPop=='AFR',]
# deleted individual where mother or father are in data base
balise_other<-(info_ind_afr$Paternal.ID!="0" & (info_ind_afr$Paternal.ID %in% info_ind_afr$Individual.ID)) | 
(info_ind_afr$Maternal.ID!="0" & (info_ind_afr$Maternal.ID %in% info_ind_afr$Individual.ID)) 
write.table(info_ind_afr[!balise_other,c('Individual.ID','Individual.ID')], file='list_afr_noappar.ind',sep="\t",row.names=F, col.names=F,quote=F)
