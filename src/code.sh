#!/usr/bin/bash -d

# Output each line as it is executed (-x) and don't stop if any non zero exit codes are seen (+e)
set -x +e

#####################################################################
# Check at least one file has been given as an input
#####################################################################

if [[ -z $bam ]] && [[ -z $vcf ]] # If both BAM & VCF inputs are empty, close the app 
then
    echo "No inputs given, stopping app" 
    exit 0
fi  

#####################################################################
# Download inputs & make directories
#####################################################################

# Download all inputs and move them to the same folder 
dx-download-all-inputs --parallel

mkdir downloads 

if [[ ! -z $bam ]] # If a BAM has been given as input, move it
then 
    mv /home/dnanexus/in/bam/* /home/dnanexus/downloads/
fi

if [[ ! -z $vcf ]]
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
# Run expect to put input into SFTP
#####################################################################

# Expect allows interaction with the SFTP terminal 
# set timeout -1 means the expect script will not time out 
# Spawn runs a command
# use sshpass to pass -p (password for sftp)
# It waits to see expected return in the temrinal 
# Then sends the response 
/usr/bin/expect << EOF
    set timeout -1
    spawn sshpass -p $SFTP_pass sftp GSTT@eu-sftp.congenica.com
    expect "sftp>"
    send -- "put /home/dnanexus/downloads/*markdup*\r"
    expect "sftp>"   
    send -- "exit\r"
EOF

#####################################################################
# Check if samples uploaded & log outcomes
#####################################################################

if [[ ! -z $bam ]] # If a BAM was input
then 
    # curl will attempt to get the head of the file in the SFTP
    # We can use this to determine if the file was uploaded or not
    curl -k "sftp://eu-sftp.congenica.com/$bam_name" --user "GSTT:$SFTP_pass" --head 
    bam_upload_status=$?
    if [ $bam_upload_status == 0 ] # Retun of the above command is successfull 
    then 
        # Echo & log the outcome
        echo "BAM: $bam_name successfully uploaded to SFTP" >> ~/$path_to_logs/congenica_logs_$bam_name.txt 
    else
        echo "BAM: $bam_name not uploaded to SFTP" >> ~/$path_to_logs/congenica_logs_$bam_name.txt
    fi
fi

if [[ ! -z $vcf ]] # If a VCF was input
then 
    curl -k "sftp://eu-sftp.congenica.com/$vcf_name" --user "GSTT:$SFTP_pass" --head
    vcf_upload_status=$?
    if [ $vcf_upload_status == 0 ] # Retun of the above command is successfull  
    then 
        echo "VCF: $vcf_name successfully uploaded to SFTP" >> ~/$path_to_logs/congenica_logs_$vcf_name.txt
    else
        echo "VCF: $vcf_name not uploaded to SFTP" >> ~/$path_to_logs/congenica_logs_$vcf_name.txt
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

if [[ ! -z $bam ]] && [[ ! -z $vcf ]] # If BAM & VCF given as inputs
then
    echo "BAM & VCF inputs given"
    if [ "$bam_upload_status" -eq "0" ] && [ "$vcf_upload_status" -eq "0" ] # If both successfully uploaded
    then 
        echo "BAM & VCF successfuly uploaded"
        exit 0
        mark-success
    else
        echo "Upload unsuccessfull"
        exit 1
    fi
elif [[ ! -z $bam ]] &&  [[ -z $vcf ]] # If only a BAM was inputted 
then 
    echo "BAM only given as input"
    if [ "$bam_upload_status" -eq "0" ] 
    then
        echo "BAM successfuly uploaded"
        exit 0
        mark-success
    else
        echo "BAM upload unsuccessfull"
        exit 1
    fi
elif [[ -z $bam ]] &&  [[ ! -z $vcf ]]
then 
    echo "VCF only given as input"
    if [ "$vcf_upload_status" -eq "0" ]
    then
        echo "VCF uploaded successfully"
        exit 0
        mark-success
    else 
        echo "VCF upload unsuccessfull"
        exit 1
    fi
fi








