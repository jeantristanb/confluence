include {strmem} from './utils.nf'

process extractindfile{
 input :
  path(fileI)
  val(out)
 output :
  path(out)
 script :
 """
 awk '{print \$1\"\\t\"\$2}' $fileI > $out
 """
}



process computefreq_plink{
  cpus params.cpu_plink
  memory { strmem(params.memory_plink) + 5.GB * (task.attempt -1) }
  errorStrategy { task.exitStatus in 137..144 ? 'retry' : 'terminate' }
  maxRetries 10
  input :
    tuple path(bed), path(bim), path(fam)
     path(list_ind)
     val(outdir)
     val(outpat)
  output :
     tuple file("${headout}.frq")
  script :
    headout=output
    plkf=bed.baseName
    covar2 = (covar=="") ? "" : " --covar $covar "
    """
    plink -bfile $plkf --keep $list_ind --freq -out $headout"_tmp" --keep-allele-order --threads ${params.cpu_plink}
    merge_freqandbim.py  --freq  ${headout}_tmp.frq --bim $bim --out ${headout}.frq
    """
}

process clean_plink{
 cpus params.cpu_plink
 memory { strmem(params.memory_plink) + 5.GB * (task.attempt -1) }
 input:
  tuple path(bed), path(bim), path(fam)
  path(snp_exclude)
  path(snp_include)
  path(indkeep)
  val(outdir)
  val(outpat)
  publishDir "$outdir/",  mode:'copy'
 output:
  tuple path("${outfile}.bed"),  path("${outfile}.bim"), path("${outfile}.fam")
 script:
  bfile=bed.baseName
  outfile=outpat+"_clean"
  snp_exclude=snp_exclude.toString()
  snp_include=snp_include.toString()
  range=(snp_exclude=="01" || snp_exclude=="02" || snp_exclude=="03") ? "" : " --exclude range $snp_exclude "
  range2=(snp_include=="01" || snp_include=="02" ||snp_include=="03") ? "" : " --extract range $snp_include "
  maf=(params.plink_maf==0) ? "" : " --maf ${params.plink_maf}"
  """
  plink --bfile $bfile --threads ${params.cpu_plink}  $range --make-bed --out $outfile $maf --keep $indkeep --keep-allele-order $range2
  """
}

