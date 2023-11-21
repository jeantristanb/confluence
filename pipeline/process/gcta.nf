include {strmem} from './utils.nf'

process format_sumstat{
 input :
    tuple path(sumstat), path(infofile), val(outdir),val(outpat)
 publishDir "${params.output_dir}/$outdir/",  mode:'copy'
 output :
   path(outpat)
 script :
   //  format_gcta.py: error: the following arguments are required: --sumstat, --freq_header, --se_header, --n_header, --chro_header, --bp_header, --beta_header
    chrbpheader=""
    chrbpheader=(params.sumstat_head_chr=="") ? chrbpheader : " $chrbpheader --chro_header ${params.sumstat_head_chr} "
    chrbpheader=(params.sumstat_head_a1=="") ? chrbpheader : " $chrbpheader --a1_header ${params.sumstat_head_a1} "
    chrbpheader=(params.sumstat_head_a2=="") ? chrbpheader : " $chrbpheader --a2_header ${params.sumstat_head_a2} "
    chrbpheader=(params.sumstat_head_pval=="") ? chrbpheader : "$chrbpheader --pval_header ${params.sumstat_head_pval} "
    chrbpheader=(params.sumstat_head_rs=="") ? chrbpheader : " $chrbpheader --rs_header ${params.sumstat_head_rs} "
    chrbpheader=(params.sumstat_head_bp=="") ? chrbpheader : " $chrbpheader  --bp_header ${params.sumstat_head_bp} "
    chrbpheader=(params.sumstat_head_beta=="") ? chrbpheader : " $chrbpheader --beta_header ${params.sumstat_head_beta} "
    chrbpheader=(params.sumstat_head_se=="") ? chrbpheader : " ${chrbpheader}  --se_header ${params.sumstat_head_se} "
    chrbpheader= (params.sumstat_head_freq=="") ? chrbpheader:" ${chrbpheader} --freq_header ${params.sumstat_head_freq} "
    chrbpheader=(params.sumstat_head_n=="") ? chrbpheader:" ${chrbpheader}   --n_header ${params.sumstat_head_n} "
    chrbpheader=(params.sumstat_n=="") ? chrbpheader:" ${chrbpheader}   --n ${params.sumstat_n} "
    infofile = (infofile.toString()!="01" && infofile.toString()!="02")  ? " --file_rschrbp $infofile " : ""
    """
    format_gcta.py $chrbpheader $infofile --out $outpat --sumstat $sumstat --just_listpos $params.gcta_justlistpos
    """
}

process run_gctb_sumstat {
 memory { strmem(params.memory_gctb) + 5.GB * (task.attempt -1) }
 errorStrategy { task.exitStatus in 130..150 ? 'retry' : 'terminate' }
 maxRetries 10
 input :
    path(sumstat)
    path(ld_bin)
    path(ld_info)
    val(out)
 publishDir "${params.output_dir}/gctb/",  mode:'copy'
 output :
   path("output*")
 script :
   output=out+'_gctb'
   tmpld=ld_bin.join(",")
   println tmpld
   gctbimp=(params.gctb_impute_n==0) ? "" : " --impute-n "
   """
   echo $tmpld|awk -F\",\" '{for(cmt=1;cmt<=NF;cmt++)print \$cmt}' | sed 's/.bin\$//g' > tmp.mldmlist
   ${params.gctb_bin} --gwas-summary $sumstat --sbayes ${params.gctb_bayesmod} --hsq  ${params.gctb_hsqinit} --wind ${params.gctb_wind_mb} --maf ${params.sumstat_maf} --out ${output} --mldm tmp.mldmlist ${params.gctb_otheroption} $gctbimp | tee -a $output".txt"
   """
}
