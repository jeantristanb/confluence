# Run GCTB to estimate heritability
* option to defined action of script : `--model` :
  * `gctb` : run gctb to estimated ld [default]
  * `gctb_ld` : build ld matrix

## general option 
 * `output_pat` : output of pattern
 * `output_dir` : directory outpuyt
 * `gctb_bin` [gctb]
 
## heritability using sumstat
 * `sumstat` : sumstat file can  be gzip
   * `sumstat_head_chr` : chromosome header
   * `sumstat_head_bp` : bp header
   * `sumstat_head_a1` : effect allele header
   * `sumstat_head_a2` : non effect allele header
   * `sumstat_head_rs` : rs header
   * `sumstat_head_pval` : pval header
   * `sumstat_head_se` : standard error header
   * `sumstat_head_beta` : beta header
   * `sumstat_head_freq` : frequences
   * nvalue can be done as argument or header of sumstat:
    * `sumstat_head_n` : one or n header, separated by header
    * `sumstat_n` :  n values [int]
 * matrice ld :
  * `gctb_ld_bin` :  file contained list of ld build with gctb, extension bin
  * `gctb_ld_info` :  file contained list of info of `gctb_ld_bin` build with gctb, extension bin 
 * model [see more information](https://cnsgenomics.com/software/gctb/#Bayesianalphabet) :
  * `gctb_bayesmod` : model S, R [default S], tested just with S
  * `gctb_hsqinit` : heritability (see option `--hsq` of gctb)
 * `update_rsid` : file contained each position of 

###created file for update rsid :
'''
sumtat=filesumtat
if [ ! -f allpos ]
then
rm -f allpos
# Chrom              ID     GenPos         PhysPos     A1     A2       A2Freq      Index  WindStart    WindEnd   WindSize       WindWidth          N     SamplVar        LDsum
for file in  `ls ../ressource/ukb_50k_bigset_2.8M/*.info`
do
sed '1d' $file | awk '{print $1"\t"$4"\t"$2}' >> allpos
done
fi
'''

### Created file for matrice
 
'''
ls  ../ressource/ukb_50k_bigset_2.8M/*.bin > list_bin
ls  ../ressource/ukb_50k_bigset_2.8M/*.info > list_info
'''


### example run of command line 
'''
#ID CHR POS ALT REF AF_ALT beta.ALT SE P Rsq N_case N_control
hchr=CHR;hbp=POS;ha1=ALT;ha2=REF;hrs=ID;hp=P;hbeta=beta.ALT;hse=SE;hn="N_case,N_control";hfreq=AF_ALT
#gctb_listld  
/home/jeantristan/Cancer/BC_gwas/confluence/confluence/pipeline/main.nf  --sumstat $sumstat   --sumstat_head_chr $hchr --sumstat_head_bp $hbp --sumstat_head_a1 $ha1 --sumstat_head_a2 $ha2 --sumstat_head_rs $hrs --sumstat_head_pval $hp --sumstat_head_beta $hbeta --sumstat_head_se $hse --sumstat_head_n $hn --sumstat_head_freq $hfreq  --update_rsid allpos --gctb_ld_bin list_bin --gctb_ld_info list_info -resume -profile slurmSingularity
'''
#
'''

#run on dna-nexus

see manual [here](https://documentation.dnanexus.com/user/running-apps-and-workflows/running-nextflow-pipelines)



```
#connection
dx login or dx login --toker
dx mkdir Aim2_Polygenicity/jeantristan

dx build --nextflow \
  --repository https://github.com/jeantristanb/confluence \
  --destination Aim2_Polygenicity/jeantristan/heritability
```

command line after connexion
```
dx ls Aim2_Polygenicity/
```