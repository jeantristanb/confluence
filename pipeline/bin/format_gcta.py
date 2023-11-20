#!/usr/bin/env python3
import argparse
from math import sqrt
import sys
from scipy import stats
import gzip
import os

def spl_gz(z,sep) :
   return z.decode('utf-8').replace('\n','').split(sep)

def spl_nogz(z,sep) :
   return z.replace('\n','').split(sep)

def openf(File) :
  def is_gz_file(filepath):
      with open(filepath, 'rb') as test_f:
        return test_f.read(2) == b'\x1f\x8b'
  def checkexists(path_to_file) :
    if exists(path_to_file)==False :
     sys.exist('file '+ path_to_file+' doesn t exist')
  balisegz=False
  if is_gz_file(File) :
    readf=gzip.open(File)
    balisegz=True
    spl=spl_gz
  else :
    readf=open(File)
    spl=spl
  return (readf, spl)


def parseArguments():
    parser = argparse.ArgumentParser(description='format file for gcta, append N and frequencie if not present using bed file')
    parser.add_argument('--sumstat',type=str,required=True, help="association files")
    parser.add_argument('--out', type=str,help="out of tex file",default="test.tex")
    parser.add_argument('--rs_header',type=str,required=True,help="rs header in inp files")
    parser.add_argument('--pval_header',type=str,required=True,help="pvalue header in inp files")
    parser.add_argument('--freq_header',type=str,required=True,help="freq header in inp files",default=None)
    parser.add_argument('--a1_header',type=str,required=True,help="a1 header in inp files")
    parser.add_argument('--a2_header',type=str,required=True,help="a2 header in inp files")
    parser.add_argument('--se_header',type=str,required=True,help="se header in inp files")
    parser.add_argument('--n_header',type=str,help="n header in inp files", required=True)
    parser.add_argument('--chro_header',type=str,required=True,help="n header in inp files")
    parser.add_argument('--bp_header',type=str,help="bp header", required = True)
    parser.add_argument('--beta_header',type=str,required=True,help="beta header in inp files")
    parser.add_argument('--file_rschrbp',type=str,required=False,help="chr bp rs")
    args = parser.parse_args()
    return args

args = parseArguments()

gwas=args.sumstat

balise_changers=False
if args.file_rschrbp :
  balise_changers=True
  f=open(args.file_rschrbp)
  dic_rs={}
  for l in f :
    spl=l.replace('\n','').split()
    dic_rs[spl[0]+':'+spl[1]]=spl[2]
  f.close()


(readsum,split)=openf(args.sumstat)

header=split(openf(readsum.readline()))
rsh=header.index(args.rs_header)
a1h=header.index(args.a1_header)
a2h=header.index(args.a2_header)
seh=header.index(args.se_header)
betah=header.index(args.beta_header)
chroh=header.index(args.chro_header)
freqh=header.index(args.freq_header)
bph=header.index(args.bp_header)
nh=[head.index(x) for x in args.n_header.split()]
ph=header.index(args.pval_header)

#SNP A1 A2 freq b se p N 
headgcta=["SNP","A1","A2","freq","b","se","p", "N"]


write_sum=open(args.out, 'w')
for r in readsum :
   splr=split(r)
   chro=splr[chroh]
   bp=splr[bph]
   a1=splr[a1h]
   a2=splr[a1h]
   rs=splr[rsh]
   beta=splr[betah]
   se=splr[seh]
   p=splr[ph]
   frq=splr[freqh]
   n=sum([int(x) for x in nh])
   if balise_changers :
    chrbp=chro+':'+bp
    if chrbp in dic_rs :
       rs=dic_rs[chrbp]
   write_sum.write(" ".join([rs,a1,a2,freq, beta, se, p,str(n)])+'\n')
write_sum.close()

