# 1. Goal

The goal of this project is to compare 4 germline variant callers and produce a consensus that has a better accuracy (sensitivity, specificity) than any one caller alone:
* [DeepVariant](https://github.com/google/deepvariant) 
* [Freebayes](https://github.com/freebayes/freebayes?tab=readme-ov-file) 
* [Strelka2](https://github.com/Illumina/strelka)
* [Octopus](https://github.com/luntergroup/octopus) 
  
The idea is to develop a machine learning model based on various features of the read alignment. Training data will be obtained from the [genome-in-a-bottle project](https://www.nist.gov/programs-projects/genome-bottle), Illumina platinum genomes

# 2. Data

Currently, the results are stored on the ICR server. Project data is stored in /liz.9.11.19_GMVLE/.

## 2.1 Original input data to the ICR reannotate pipeline

Original ashkenazi father vcf file is stored in the following location: https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/AshkenazimTrio/HG003_NA24149_father/NISTv4.2.1/GRCh38/

* [The true VCF file (confident regions) of the Ashkenazi father (HG003)](https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/AshkenazimTrio/HG003_NA24149_father/NISTv4.2.1/GRCh38/HG003_GRCh38_1_22_v4.2.1_benchmark.vcf.gz): HG003_GRCh38_1_22_v4.2.1_benchmark.vcf.gz
* [Index for this VCF file](https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/AshkenazimTrio/HG003_NA24149_father/NISTv4.2.1/GRCh38/HG003_GRCh38_1_22_v4.2.1_benchmark.vcf.gz.tbi): HG003_GRCh38_1_22_v4.2.1_benchmark.vcf.gz.tbi
* (*Not necessary in this project*) [BED file that is required to know what those confident region are](https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/AshkenazimTrio/HG003_NA24149_father/NISTv4.2.1/GRCh38/HG003_GRCh38_1_22_v4.2.1_benchmark_noinconsistent.bed): HG003_GRCh38_1_22_v4.2.1_benchmark_noinconsistent.bed

## 2.2 Human reference genome

SDF of the refernce genome is located on the ICR server: /mnt/results/Liz.9.14/compare-vcf-file/human_REF_SDF

* [grch38 reference genome](https://ftp.ensembl.org/pub/release-110/fasta/homo_sapiens/dna/)

# 3. Approach
## 3.1. ICR reannotate pipeline

First, we utilized the ICR reannotate pipeline with data from the Genome in a Bottle project, employing four germline variant callers (DeepVariant, Freebayes, Strelka2, and Octopus) to generate the corresponding VCF files.

Four VCF files (one per caller) for the Ashkenazim father (HG003_NA24149) are created using the [ICR-reannotate-pipeline](https://github.com/lizard-bio/ICR-reannotate-pipeline). (fastq files were used as input)

   * liz.9.11.19_GMVLE/results/variants/HG003_NA24149_Ashkenazim_father.trim.dv.vcf
   * liz.9.11.19_GMVLE/results/variants/HG003_NA24149_Ashkenazim_father.trim.fb.vcf
   * liz.9.11.19_GMVLE/results/variants/HG003_NA24149_Ashkenazim_father.trim.oc.vcf
   * liz.9.11.19_GMVLE/results/variants/HG003_NA24149_Ashkenazim_father.trim.st.vcf



## 3.2 Evaluation of the variant callers

The next step is to evaluate the accuracy of each variant caller against a truth set (genome in a bottle). We will compare the results of the four variant callers to the truth set to determine the sensitivity, specificity, and accuracy of each caller. [RTG Tools](https://realtimegenomics.github.io/rtg-tools/rtg_command_reference.html#vcfeval) will be used to compare the VCF files to the truth set.

## 3.3 Combine the results of the variant callers

Due to the inherent differences in germline variant callers, the accuracy and results can vary even when applied to the same dataset.(For example, a variant detected at a specific chromosomal position by Caller A might not be identified by Caller B). Therefore, I need to extract all variant loci detected across the four VCF files, acknowledging that some loci may have been identified as variants by only one or two of the variant callers. 

*Deprecated: We performed a second round of variant calling using BAM files and a reference genome to obtain genome VCF (gVCF) files. Typically, gVCF files aggregate positions with no variants into blocks. Next, we aim to filter the broken gVCF files using all the variant positions identified in the initial four VCF files. This process should yield four filtered gVCF files, each containing all the variant positions previously mentioned.*

*These files are located here:*
* *liz.9.11.19_GMVLE/second-results/DV*
* *liz.9.11.19_GMVLE/second-results/ST*
* *liz.9.11.19_GMVLE/second-results/FB*
* *liz.9.11.19_GMVLE/second-results/fillin_gaps/fillin_gaps_DV.vcf*
* *liz.9.11.19_GMVLE/second-results/fillin_gaps/fillin_gaps_FB.vcf*
* *liz.9.11.19_GMVLE/second-results/fillin_gaps/fillin_gaps_ST.vcf*
* *liz.9.11.19_GMVLE/second-results/fillin_gaps/merge_DV.vcf*
* *liz.9.11.19_GMVLE/second-results/fillin_gaps/merge_ST.vcf*


## 3.4 Assess potential accuracy improvements
* The main features to consider in this model would be Quality (of the variant call), Filter, and depth (of sequencing)
* Missing values should be imputed based on the minimum value of the variant caller. The rationale being that if a variant is missing from a .vcf file, it implies that the variant did not pass the minimum quality threshold of the variant caller
* Model should be trained on a subset of variants (chr 22, shortest chromosome)
* Then, we should evaluate the accuracy of the model, compare to the accuracy of the 4 variant callers alone. → We need to know first if accuracy improvements are possible before refining the model and extending to the whole genome.
* An important evaluation should be done by analysing specifically the accuracy of different variant types (i.e. SNP, Insertion, Deletion)
Should it be trained to identify variants (True/False) or genotypes (Ref/Ref, Ref/Alt, Alt/Alt)?

## 3.5 Further testing
If successful, the model will be refined with additional features and tested on larger genomic regions to develop a more accurate consensus variant caller. It will also be tested on Mark's variants and compared with the existing consensus call (overlap between the two, impact/consequence of differing variants)
