configfile: "config.yaml"

with open(config['SAMPLES']) as fp:
    SAMPLES= fp.read().splitlines()

rule all: 
   input:
       expand("{sample}_Aligned.out.sam", sample = SAMPLES),
       expand("{sample}_fusions.tsv", sample = SAMPLES),

if config['PAIRED']:
    rule trim:
       input:
           r1 = "{sample}.r_1.fq.gz",
           r2 = "{sample}.r_2.fq.gz"
       output:
           "galore/{sample}.r_1_val_1.fq.gz",
           "galore/{sample}.r_2_val_2.fq.gz"
       conda: 'env/env-trim.yaml'
       shell:
           """
           mkdir -p galore
           mkdir -p fastqc
           trim_galore --gzip --retain_unpaired --trim1 --fastqc --fastqc_args "--outdir fastqc" -o galore --paired {input.r1} {input.r2}
           """
    rule align:
        input:
           "galore/{sample}.r_1_val_1.fq.gz",
           "galore/{sample}.r_2_val_2.fq.gz"
        output:
             "{sample}_Aligned.out.sam"
        params:
             threads = config['THREADS'],
             gtf = config['GTF'],
             prefix = "{sample}_",
             index = config['INDEX']
        shell:
           """
           STAR --genomeDir {params.index} --runThreadN {params.threads} --chimOutType WithinBAM  --readFilesCommand zcat  --readFilesIn {input[0]} {input[1]}  --outFileNamePrefix {params.prefix} --sjdbGTFfile {params.gtf}  --twopassMode Basic
           """


else:
     rule trim:
       input:
           "{sample}.fq.gz",

       output:
           "galore/{sample}_trimmed.fq.gz",
       conda: 'env/env-trim.yaml'
       shell:
           """
           mkdir -p galore
           mkdir -p fastqc
           trim_galore --gzip --retain_unpaired --trim1 --fastqc --fastqc_args "--outdir fastqc" -o galore {input}
           """

     rule align:
        input:
              "galore/{sample}_trimmed.fq.gz"
        output:
             "{sample}_Aligned.out.sam"
        params:
             threads = config['THREADS'],
             gtf = config['GTF'],
             prefix = "{sample}_",
             index = config['INDEX']
        shell:
           """
           STAR --genomeDir {params.index} --runThreadN {params.threads} --chimOutType WithinBAM --readFilesCommand zcat --readFilesIn {input}  --outFileNamePrefix {params.prefix} --sjdbGTFfile {params.gtf}  --twopassMode Basic
           """


rule arriba: 
      input:
         "{sample}_Aligned.out.sam"
      params: 
        gtf = config['GTF'],
        genome = expand("{genome}.fa", genome=config['GENOME']),
        blacklist = expand("{blacklist}", blacklist =config['BLACKLIST']), 
        known_fusion = expand("{known_fusion}", known_fusion=config['KNOWN_FUSION']),
        protein = expand("{protein}", protein =config['PROTEIN'])
      output:
         "{sample}_fusions.tsv",
         "{sample}_fusions.discarded.tsv"  
      shell: 
        """
         {config[ARRIBA]}  -x {input} -g {params.gtf}  -a {params.genome} -o {output[0]} -O {output[1]} -b {params.blacklist} -k {params.known_fusion} -p {params.protein} 
        """
