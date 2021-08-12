 # dnanexus_WES_Cognenica_SFTP_upload v0.1

A bash script has been created to semi automate the WES sample SFTP upload process, whilst the app is being developed
To use the bash script:
1) dx select DNA Nexus project containing the WES run you wish to upload. Ensure you are in the root of the project
2) The bash script can be found in 001_ToolsReferenceData/Apps/WES_Congenica_SFTP_upload_V0.1.sh
3) Invoke a cloud workstation, passing the path of the WES_Congenic_SFTP_upload.sh to the -ifids to pull the bash script into the workstation
4) Run the bash script 
5) Terminate the cloud workstation when the bash script has finished 

The bash script:
1) Downloads required packages 
2) Uses ssh-keyscan gathers the SSH host key of the Congenica SFTP
3) Downloads required keys and files (*markdup_Haplotyper.vcf.gz & *markdup.bam)
4) Uses the expect package to run the sshpass command to connect to the SFTP
5) Then transfers the BAMs and VCFs and exits the SFTP



## What does this app do?

This app will upload VCFs (*markdup_Haplotyper.vcf.gz*)  & BAMs (*markdup.bam*) from WES runs to the Congenica SFTP to be inputted into Congenica 

## What are typical use cases for this app?

After quality checks of a WES run have been completed, this app will be run to upload the samples to Congenica 

## What data are required for this app to run?

VCFs (*markdup_Haplotyper.vcf.gz*)  & BAMs( *markdup.bam*) from WES run

## How does this app work?

This app will be run by sshing on to the workstation and running a bash script of dx run commands (still to be created)



## This app was made by Viapath Genome Informatics
