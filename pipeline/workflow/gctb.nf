include {format_sumstat} from '../process/gcta.nf'
include {run_gctb_sumstat} from '../process/gcta.nf'

workflow gctb {
  sumstat=channel.fromPath(params.sumstat, checkIfExists:true)
  if(params.update_rsid!='')rsidfile=channel.fromPath(params.update_rsid, checkIfExists:true)
  format_sumstat(sumstat.combine(rsidfile).combine(channel.from(params.output)))
  listfile_gtc_bin=Channel.fromPath(file(params.gctb_ld_bin, checkIfExists:true).readLines(), checkIfExists:true).collect()
  listfile_gtc_info=Channel.fromPath(file(params.gctb_ld_info, checkIfExists:true).readLines(), checkIfExists:true).collect()
  run_gctb_sumstat(format_sumstat.out, listfile_gtc_bin, listfile_gtc_info, channel.from(params.output))

}
