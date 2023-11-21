#!/usr/bin/env nextflow

import java.nio.file.Paths;
import sun.nio.fs.UnixPath;
import java.security.MessageDigest;

include {gctb} from './workflow/gctb.nf'

workflow {
  if(params.model=="gctb")gctb()

}
