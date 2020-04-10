


# Prototyping - Compare mgenie with predixcan results


## PrediXcan method
```
cd /sc/hydra/projects/va-biobank/resources/genie-resources/polyxcan/test
conda activate py2
python /sc/hydra/projects/va-biobank/resources/genie-resources/software/PrediXcan/Software/PrediXcan.py \
  --predict \
  --dosages /sc/hydra/projects/va-biobank/resources/genie-resources/qc-dna/1000g \
  --dosages_prefix 1kg..eur.biallele.snps.maf0.01.nonAmbi.onlyRs.recode.chr \
  --samples /sc/hydra/projects/va-biobank/resources/genie-resources/qc-dna/1000g/1kg..eur.biallele.snps.maf0.01.nonAmbi.onlyRs.recode.chr.nosex \
  --weights /sc/hydra/projects/va-biobank/resources/genie-resources/polyxcan/v1.dbs/ChipSeqH3K4me3_H3K4me3_alpha0.5_window5e4_filtered.db \
  --output_prefix /sc/hydra/projects/va-biobank/resources/genie-resources/polyxcan/test/results/test

#   --genelist /sc/hydra/projects/va-biobank/resources/genie-resources/polyxcan/test/testgenes \
```

## mgenie method
```
cd /sc/hydra/projects/va-biobank/resources/genie-resources/polyxcan/test_mgenie/
conda activate genie
genie predixcan predict \
  --gds=/sc/hydra/projects/va-biobank/resources/genie-resources/qc-dna/1000g/1kg.gds \
  --db=/sc/hydra/projects/va-biobank/resources/genie-resources/polyxcan/v1.dbs/ChipSeqH3K4me3_H3K4me3_alpha0.5_window5e4_filtered.db \
```  



please check here:
8:11
/sc/hydra/projects/roussp01a/Wen/ATAC_seq/
8:11
and in subfolders: PEC_Capstone/scripts/  
8:11
is the capstone RNAseq
8:12
PEC_Transcript/scripts/  stores isoform of capstone

ATAC: Crawford.ATAC.false/scripts/  chipseq: ` Chip_seq/scripts/`




