import pandas as pd
import gzip

def read_vcf(file: str) -> pd.DataFrame:
    num_header = 0

    if file.endswith(".gz"):
        with gzip.open(file, "rt") as f:
            for line in f.readlines():
                if line.startswith("##"):
                    num_header += 1
                else:
                    break

    else:
        with open(file) as f:
            for line in f.readlines():
                if line.startswith("##"):
                    num_header += 1
                else:
                    break

    vcf = pd.read_csv(file, sep="\t", skiprows=num_header)
    vcf = vcf.rename({"#CHROM": "CHROM"}, axis=1)
    return vcf