# 1. Goal

The goal of this project is to compare 4 germline variant callers (DeepVariant, Freebayes, Strelka2 and Octopus) and produce a consensus that has a better accuracy (sensitivity, specificity) than any one caller alone. Idea is to develop a machine learning model based on various features of the read alignment. Training data will be obtained from the genome-in-a-bottle project, Illumina platinum genomes

# 2. Data

Currently, the results are stored on the ICR server. Project data is stored in /liz.9.11.19_GMVLE/.

# 3. Approach
## 3.1. ICR reannotate pipeline

First, we utilized the ICR reannotate pipeline with data from the Genome in a Bottle project, employing four germline variant callers (DeepVariant, Freebayes, Strelka2, and Octopus) to generate the corresponding VCF files.

Four VCF files (one per caller) for the Ashkenazim father (HG003_NA24149) are created using the [ICR-reannotate-pipeline](https://github.com/lizard-bio/ICR-reannotate-pipeline).
   * liz.9.11.19_GMVLE/results/variants/HG003_NA24149_Ashkenazim_father.trim.dv.vcf
   * liz.9.11.19_GMVLE/results/variants/HG003_NA24149_Ashkenazim_father.trim.fb.vcf
   * liz.9.11.19_GMVLE/results/variants/HG003_NA24149_Ashkenazim_father.trim.oc.vcf
   * liz.9.11.19_GMVLE/results/variants/HG003_NA24149_Ashkenazim_father.trim.st.vcf

Due to the inherent differences in germline variant callers, the accuracy and results can vary even when applied to the same dataset.(For example, a variant detected at a specific chromosomal position by Caller A might not be identified by Caller B). Therefore, I need to extract all variant loci detected across the four VCF files, acknowledging that some loci may have been identified as variants by only one or two of the variant callers. 

We performed a second round of variant calling using BAM files and a reference genome to obtain genome VCF (gVCF) files. Typically, gVCF files aggregate positions with no variants into blocks. 

Next, we aim to filter the broken gVCF files using all the variant positions identified in the initial four VCF files. This process should yield four filtered gVCF files, each containing all the variant positions previously mentioned. 


## Accuracy of the variant callers
Determine the accuracy of each variant caller against a truth set (genome in a bottle).

## Assess potential accuracy improvements
* The main features to consider in this model would be Quality (of the variant call), Filter, and depth (of sequencing)
* Missing values should be imputed based on the minimum value of the variant caller. The rationale being that if a variant is missing from a .vcf file, it implies that the variant did not pass the minimum quality threshold of the variant caller
* Model should be trained on a subset of variants (chr 22, shortest chromosome)
* Then, we should evaluate the accuracy of the model, compare to the accuracy of the 4 variant callers alone. → We need to know first if accuracy improvements are possible before refining the model and extending to the whole genome.
* An important evaluation should be done by analysing specifically the accuracy of different variant types (i.e. SNP, Insertion, Deletion)
Should it be trained to identify variants (True/False) or genotypes (Ref/Ref, Ref/Alt, Alt/Alt)?

## Further testing
If successful, the model will be refined with additional features and tested on larger genomic regions to develop a more accurate consensus variant caller. It will also be tested on Mark's variants and compared with the existing consensus call (overlap between the two, impact/consequence of differing variants)

## Data




* 

* liz.9.11.19_GMVLE/second-results/DV
* liz.9.11.19_GMVLE/second-results/ST
* liz.9.11.19_GMVLE/second-results/FB
* liz.9.11.19_GMVLE/second-results/fillin_gaps/fillin_gaps_DV.vcf
* liz.9.11.19_GMVLE/second-results/fillin_gaps/fillin_gaps_FB.vcf
* liz.9.11.19_GMVLE/second-results/fillin_gaps/fillin_gaps_ST.vcf
* liz.9.11.19_GMVLE/second-results/fillin_gaps/merge_DV.vcf
* liz.9.11.19_GMVLE/second-results/fillin_gaps/merge_ST.vcf