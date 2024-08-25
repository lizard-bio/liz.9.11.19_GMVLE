The goal of this project is to compare 4 germline variant callers (DeepVariant, Freebayes, Strelka2 and Octopus) and produce a consensus that has a better accuracy (sensitivity, specificity) than any one caller alone. Idea is to develop a machine learning model based on various features of the read alignment. Training data will be obtained from the genome-in-a-bottle project, Illumina platinum genomes

First, we utilized the ICR reannotate pipeline with data from the Genome in a Bottle project, employing four germline variant callers (DeepVariant, Freebayes, Strelka2, and Octopus) to generate the corresponding VCF files.

Due to the inherent differences in germline variant callers, the accuracy and results can vary even when applied to the same dataset.(For example, a variant detected at a specific chromosomal position by Caller A might not be identified by Caller B). Therefore, I need to extract all variant loci detected across the four VCF files, acknowledging that some loci may have been identified as variants by only one or two of the variant callers.  

We performed a second round of variant calling using BAM files and a reference genome to obtain genome VCF (gVCF) files. Typically, gVCF files aggregate positions with no variants into blocks. 

Next, we aim to filter the broken gVCF files using all the variant positions identified in the initial four VCF files. This process should yield four filtered gVCF files, each containing all the variant positions previously mentioned. 

