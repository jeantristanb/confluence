include {format_sumstat} from './process/gctb.nf'

workflow gctb {
  sumstat=channel.fromPath(params.sumstat, checkIfExists:true)
  format_sumstat(sumstat.combine())
  


}
