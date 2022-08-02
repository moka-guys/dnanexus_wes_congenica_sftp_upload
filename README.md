 # dnanexus_wes_congenica_sftp_upload v1.0

## What does this app do?

This app upload can upload a VCF (*markdup_Haplotyper.vcf.gz*) and/or a BAM (*markdup.bam*) from WES runs to the Congenica SFTP to be inputted into Congenica 

Both inputs are optional but if no inputs are given, the app will fail

## What are typical use cases for this app?

After quality checks of a WES run have been completed, this app will be run to upload relevant samples to Congenica on a sample by sample basis

## What data is required for this app to run?

 A VCF (*markdup_Haplotyper.vcf.gz*) and/or a BAM( *markdup.bam*) 

## How does this app work?

This app will need to be run in WES runs with applicable samples, a more automated process is being developed

## What does this app output?

A log file which records if the samples selected were uploaded successfully to the SFTP will be uploaded to a folder called congenica_logs in the DNANexus runfolder

## This app was made by Viapath Genome Informatic
