process format_sumstat{
 input :
    tuple path(sumstat), path(infofile), val(out)
 output :
   path(sumstat_format)
 script :
    chrbpheader=""
    chrbpheader=(params.sumstat_head_chr=="") ? chrbpheader : " $chrbpheader --head_chr ${params.sumstat_head_chr} "
    chrbpheader=(params.sumstat_head_a1=="") ? chrbpheader : " $chrbpheader --a1_header ${params.sumstat_head_a1} "
    chrbpheader=(params.sumstat_head_a2=="") ? chrbpheader : " $chrbpheader --a2_header ${params.sumstat_head_a2} "
    chrbpheader=(params.sumstat_head_pval=="") ? chrbpheader : "$chrbpheader --pval_header ${params.sumstat_head_pval} "
    chrbpheader=(params.sumstat_head_rs=="") ? chrbpheader : " $chrbpheader --rs_header ${params.sumstat_head_rs} "
    chrbpheader=(params.sumstat_head_bp=="") ? chrbpheader : " $chrbpheader  --head_bp ${params.sumstat_head_bp} "
    chrbpheader=(params.sumstat_head_beta=="") ? chrbpheader : " $chrbpheader --head_beta ${params.sumstat_head_beta} "
    chrbpheader=(params.sumstat_head_se=="") ? chrbpheader : " ${chrbpheader}  --head_se  ${params.sumstat_head_se} "
    chrbpheader= (params.sumstat_head_freq=="") ? chrbpheader:" ${chrbpheader} --head_freq  ${params.sumstat_head_freq} "
    chrbpheader=(params.sumstat_head_n=="") ? chrbpheader:" ${chrbpheader}   --head_n ${params.sumstat_head_n} "
    infofile = (infofile.toString()!="01"i& infofile.toString()!="02")  ? " --file_rschrbp $infofile " ? ""
    """
    format_gcta.py $chrbpheader $infofile --out $out
    """
}

process run_gctb_sumstat {
 input :
    tuple path(sumstat), path(ldl), val(out)
 publishDir "${params.output_dir}/gctb/",  mode:'copy'
 output :
   path("output*")
 script :
   output=out+'_gctb'
   """
   ${params.gctb_bin} --gwas-summary $sumstat --bayes ${params.gctb_bayesmod} --hsq  ${params.gctb_hsqinit} --wind ${params.gctb_wind_mb} --mldm  $ldl --maf ${params.sumstat_maf} --out ${}
   """
}
