 # dnanexus_wes_congenica_sftp_upload v0.1

## What does this app do?

This app uploads VCFs (*markdup_Haplotyper.vcf.gz*)  & BAMs (*markdup.bam*) from WES runs to the Congenica SFTP to be inputted into Congenica 

Both inputs are optional

## What are typical use cases for this app?

After quality checks of a WES run have been completed, this app will be run to upload revelvant samples to Congenica on a sample by sample basis

## What data are required for this app to run?

 VCFs (*markdup_Haplotyper.vcf.gz*)  &/or BAMs( *markdup.bam*) 

## How does this app work?

This app will need to be run in WES runs with applicable samples, a more automated process is being developed

## What does this app output?

A log file which records if the samples selected were uploaded successfully to the SFTP will be uploaded to a folder called congenica_logs in the DNANexus runfolder

## This app was made by Viapath Genome Informatics
