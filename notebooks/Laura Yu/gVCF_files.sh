# performed a second round of variant calling using BAM files and a reference genome to obtain genome VCF (gVCF) files. Typically, gVCF files aggregate positions with no variants into blocks. 
# 1. Freebayes

docker run --rm \
  -v /home/dingrongruo.yu/liz.9.11.19_GMVLE/ICR-reannotate-pipeline-master/references:/references \
  -v /home/dingrongruo.yu/liz.9.11.19_GMVLE/results/mapping:/mapping \
  biocontainers/freebayes:v1.2.0-2-deb_cv1 \
  freebayes -f /references/hsapiens.fa /mapping/HG003_NA24149_Ashkenazim_father.trim.sort.markdup.bam --gvcf >/home/dingrongruo.yu/liz.9.11.19_GMVLE/second-results/FB/HG003_NA24149_Ashkenazim_father_g_fb.vcf

# 2. DeepVariant 
# 2.1 Using Docker

docker run \
  -v /home/dingrongruo.yu/liz.9.11.19_GMVLE/ICR-reannotate-pipeline-master/references:/references \
  -v /home/dingrongruo.yu/liz.9.11.19_GMVLE/results/mapping:/mapping \
  -v /home/dingrongruo.yu/liz.9.11.19_GMVLE/second-results:/second-results \
  -v /home/dingrongruo.yu/liz.9.11.19_GMVLE/results/variants:/variants \
  google/deepvariant:1.5.0 \
  /opt/deepvariant/bin/run_deepvariant \
  --model_type=WGS \
  --ref=/references/hsapiens.fa \
  --reads=/mapping/HG003_NA24149_Ashkenazim_father.trim.sort.markdup.bam \
  --output_vcf=/second-results/HG003_NA24149_Ashkenazim_father.dv.vcf \
  --output_gvcf=/second-results/HG003_NA24149_Ashkenazim_father.dv.gvcf \
  --num_shards=40
# 2.1 Run directly: This code assumes that you have installed the DeepVariant tool locally and can call the run_deepvariant command directly.

run_deepvariant \
  --model_type=WGS \
  --ref=/home/dingrongruo.yu/liz.9.11.19_GMVLE/ICR-reannotate-pipeline-master/references/hsapiens.fa \
  --reads=/home/dingrongruo.yu/liz.9.11.19_GMVLE/results/mapping/HG003_NA24149_Ashkenazim_father.trim.sort.markdup.bam \
  --output_vcf=/home/dingrongruo.yu/liz.9.11.19_GMVLE/second-results/DV/HG003_NA24149_Ashkenazim_father.dv.vcf \
  --output_gvcf=/home/dingrongruo.yu/liz.9.11.19_GMVLE/second-results/DV/HG003_NA24149_Ashkenazim_father.dv.gvcf

# 3. Stelka2
# Step 1: Configure the Strelka2 Germline Workflow
python2 /home/dingrongruo.yu/strelka-2.9.2.centos6_x86_64/bin/configureStrelkaGermlineWorkflow.py \
    --bam /home/dingrongruo.yu/liz.9.11.19_GMVLE/results/mapping/HG003_NA24149_Ashkenazim_father.trim.sort.markdup.bam \
    --referenceFasta /home/dingrongruo.yu/liz.9.11.19_GMVLE/ICR-reannotate-pipeline-master/references/hsapiens.fa \
    --runDir run
    
# Step 2: Run the Strelka2 Workflow
python2 run/runWorkflow.py \
    -m local \
    -j 40 

# Step 3: Results
#Strelka2 results are typically stored in the results/variants subdirectory of the runDir directory. 
cd run/results/variants


# 4. Octopus
# 4.1 Using Docker
docker run --rm \
  -v /home/dingrongruo.yu/liz.9.11.19_GMVLE/ICR-reannotate-pipeline-master/references:/references \
  -v /home/dingrongruo.yu/liz.9.11.19_GMVLE/results/mapping:/mapping \
  -v /home/dingrongruo.yu/liz.9.11.19_GMVLE/second-results/OC:/output \
  myoctopus \
  octopus -R /references/hsapiens.fa -I /mapping/HG003_NA24149_Ashkenazim_father.trim.sort.markdup.bam -w /output -o /output/HG003_NA24149_Ashkenazim_father.oc.vcf.gz --refcall POSITIONAL --threads $(nproc)

# 4.2 Running Octopus locally
octopus -R /home/dingrongruo.yu/liz.9.11.19_GMVLE/ICR-reannotate-pipeline-master/references/hsapiens.fa -I /home/dingrongruo.yu/liz.9.11.19_GMVLE/results/mapping/HG003_NA24149_Ashkenazim_father.trim.sort.markdup.bam -o /home/dingrongruo.yu/liz.9.11.19_GMVLE/second-results/OC/HG003_NA24149_Ashkenazim_father.oc.vcf.gz --refcall POSITIONAL --threads 20

