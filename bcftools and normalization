manuals of bcftools: https://samtools.github.io/bcftools/bcftools.html#norm

#1. Filtering Variants (Threshold is 4)
bcftools filter -i 'QUAL>4' HG003_NA24149_Ashkenazim_father.trim.dv.vcf -o HG003_NA24149_Ashkenazim_father.qual.dv.vcf

#2. Normalizing VCF Files . This step is used for decomposing complex variants (both SNPs and indels) and ensuring that indels are properly left-aligned and normalized according to the reference genome.

# -m, --multiallelics -|+[snps|indels|both|any]
#  If only SNP records should be split or merged, specify ‘snps’; if both SNPs and indels should be merged separately into two records, specify ‘both; if SNPs and indels should be merged into a single record, specify ‘any’.   
# Note that multiallelic sites with both SNPs and indels will be split into biallelic sites with both -m -snps and -m -indels.

bcftools norm -f -m -both /home/dingrongruo.yu/liz.9.11.19_GMVLE/ICR-reannotate-pipeline-master/references/hsapiens.fa HG003_NA24149_Ashkenazim_father.trim.dv.vcf -o /home/dingrongruo.yu/liz.9.11.19_GMVLE/results/variants/norm/HG003_NA24149_Ashkenazim_father.norm.dv.vcf


#3. Checking for Duplicated Chromosome and Position: This command checks if there are multiple rows with the same chromosome and position but different records in the VCF file.

awk '!/^#/ {print $1"_"$2}' HG003_NA24149_Ashkenazim_father.norm.dv.vcf | sort | uniq -d | while read pos; do awk -v pos="$pos" '$1"_"$2 == pos' HG003_NA24149_Ashkenazim_father.norm.dv.vcf; done


# 4. This step is joining biallelic variants back into multiallelic records for both SNPs and indels. It is essentially the reverse of what was done in '#2'. Instead of splitting complex variants into simpler ones, this command merges them into multiallelic sites.

bcftools norm -m +any -o /home/dingrongruo.yu/liz.9.11.19_GMVLE/second-results/DV/HG003_NA24149_Ashkenazim_father.norm.gst.vcf -O v -f /home/dingrongruo.yu/liz.9.11.19_GMVLE/ICR-reannotate-pipeline-master/references/hsapiens.fa HG003_NA24149_Ashkenazim_father_g_st_broken.vcf
