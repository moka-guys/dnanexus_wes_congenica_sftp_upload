#!/usr/bin/bash -d

# Output each line as it is executed (-x) and don't stop if any non zero exit codes are seen (+e)
set -x +e

#####################################################################
# Check at least one file has been given as an input
#####################################################################

if [[ -z $bam ]] && [[ -z $vcf ]] # If both BAM & VCF inputs are empty, close the app 
then
    echo "No inputs given, stopping app" 
    exit 1
fi  

#####################################################################
# Download inputs & make directories
#####################################################################

# Download all inputs and move them to the same folder 
dx-download-all-inputs --parallel

mkdir downloads 

if [[ -n $bam ]] # If a BAM has been given as input, move it
then 
    mv /home/dnanexus/in/bam/* /home/dnanexus/downloads/
fi

if [[ -n $vcf ]]
then
    mv /home/dnanexus/in/vcf/* /home/dnanexus/downloads/
fi

ls /home/dnanexus/downloads/

# Make directory for logs #
mkdir -p ~/out/congenica_logs/

path_to_logs=out/congenica_logs

#####################################################################
# Gather the public SSH host key of the Congenica SFTP
#####################################################################

ssh-keyscan eu-sftp.congenica.com >> /root/.ssh/known_hosts

#####################################################################
# Get password for SFTP & assign it to a variable
#####################################################################

SFTP_pass=$(dx cat project-FQqXfYQ0Z0gqx7XG9Z2b4K43:congenica_SFTP_upload)

#####################################################################
# Put samples into SFTP using sshpass 
#####################################################################

if [[ -n $bam ]] # If a BAM was input
then 
    # Put the BAM in via sshpass
    sshpass -p $SFTP_pass sftp GSTT@eu-sftp.congenica.com <<< "put /home/dnanexus/downloads/*.bam"
    # Check if it was uploaded
    bam_output=$(sshpass -p $SFTP_pass sftp GSTT@eu-sftp.congenica.com <<< "ls $bam_name | tail -n1 ")
    # If the sample name is listed twice in the above output, it's been uploaded 
    bam_string_count=$(grep -o "NGS*" <<<$bam_output | wc -l)
    if [ $bam_string_count -eq 2 ]
    then 
        # Echo & log the outcome
        echo "BAM: "$bam_name" successfully uploaded to SFTP" >> ~/$path_to_logs/congenica_logs_$bam_name.txt 
    else
        echo "BAM: "$bam_name" not uploaded to SFTP" >> ~/$path_to_logs/congenica_logs_$bam_name.txt
    fi
fi

if [[ -n $vcf ]] # If a VCF was input
then 
    # Put the VCF in via sshpass
    sshpass -p $SFTP_pass sftp GSTT@eu-sftp.congenica.com <<< "put /home/dnanexus/downloads/*vcf.gz"
    # Check if it was uploaded
    vcf_output=$(sshpass -p $SFTP_pass sftp GSTT@eu-sftp.congenica.com <<< "ls $vcf_name | tail -n1 ")
    # If the sample name is listed twice, it's been uploaded 
    vcf_string_count=$(grep -o "NGS*" <<<$vcf_output | wc -l)
    if [ $vcf_string_count -eq 2 ]
    then 
        echo "VCF: "$vcf_name" successfully uploaded to SFTP" >> ~/$path_to_logs/congenica_logs_$vcf_name.txt
    else
        echo "VCF: "$vcf_name" not uploaded to SFTP" >> ~/$path_to_logs/congenica_logs_$vcf_name.txt
    fi
fi

#####################################################################
# Upload logs to DNANexus project
####################################################################

# To do dx upload, need to reset worker variable
unset DX_WORKSPACE_ID
#  Set the project the worker will upload to
dx cd $DX_PROJECT_CONTEXT_ID:

dx mkdir -p congenica_logs

# Upload logs to DNANexus project
dx upload --brief --path "$DX_PROJECT_CONTEXT_ID:/congenica_logs/" ~/out/congenica_logs/*

#####################################################################
# Determine if app should fail or succeed 
#####################################################################

if [[ -n $bam ]] && [[ -n $vcf ]] # If BAM & VCF given as inputs
then
    echo "BAM & VCF inputs given"
    if [ $bam_string_count -eq 2 ] && [ $vcf_string_count -eq 2 ] # If both successfully uploaded
    then 
        echo "BAM & VCF successfuly uploaded"
        exit 0
        mark-success
    else
        echo "Upload unsuccessfull"
        exit 1
    fi
elif [[ -n $bam ]] &&  [[ -z $vcf ]] # If only a BAM was inputted 
then 
    echo "BAM only given as input"
    if [ $bam_string_count -eq 2 ] 
    then
        echo "BAM successfuly uploaded"
        exit 0
        mark-success
    else
        echo "BAM upload unsuccessfull"
        exit 1
    fi
elif [[ -z $bam ]] &&  [[ -n $vcf ]]
then 
    echo "VCF only given as input"
    if [ $vcf_string_count -eq 2 ]
    then
        echo "VCF uploaded successfully"
        exit 0
        mark-success
    else 
        echo "VCF upload unsuccessfull"
        exit 1
    fi
fi








