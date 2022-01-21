
# Ribofilio 

[![Snakemake](https://img.shields.io/badge/snakemake-≥6.0.2-brightgreen.svg)](https://snakemake.github.io)
[![License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)


Snakemake Workflow for gene fusion from RNASeq
============================================================

This is a snakemake pipeline for gene fusion from RNASeq written by Sherine Awad. 
Currently, we use ARRIBA, but more tools are in the way. 

To run the pipeline, edit the config file to match your samples file name and reference genome. 
Your files should be by default in samples.tsv. Change this file name in config file if needed. 


    snakemake -jn 

where n is the number of cores for example for 10 cores use:


    snakemake -j10 

### Use conda 

For less froodiness, use conda:


    snakemake -jn --use-conda 


For example, for 10 cores use: 

    snakemake -j10 --use-conda 

This will pull automatically the same versiosn of tools we used. Conda has to be installed in the system, in addition to snakemake. 


### Dry Run


For a dry run use: 
  
  
    snakemake -j1 -n 


and to print command in dry run use: 

  
    snakemake -j1 -n -p 


##### TODO 
1. Add more tools for gene fusion
2. Use Strucuture variants to filter Gene fusion 
