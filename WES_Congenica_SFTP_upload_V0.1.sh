#!/usr/bin/bash -d
#########################################################################
# This bash script has been written to facilitate uploading WES samples to the Congenica SFTP
# Whilst an app is built to automate this process 
# 
# To run this bash script, create a dnanexus cloud workstation & import this file run 
# (dx run app-cloud_workstation -ifids=project-G3jf40Q0p3jg19yfKjX2j76Q:file-G4BKXJj0p3jQXq6K3v4JK01Y --ssh)
#  within the WES run you wish to upload & run the bash script 
# The bash scrpit will need to be run from the root runfolder
##############################################################################

# Enable WS to download 
unset DX_WORKSPACE_ID
dx cd $DX_PROJECT_CONTEXT_ID:

# install sshpass & expect
sudo apt-get -y install sshpass=1.05-1
sudo apt-get -y install expect=5.45-7

# Gather SSH host key of the Congenica SFTP
ssh-keyscan eu-sftp.congenica.com >> /home/dnanexus/.ssh/known_hosts

# Get password for SFTP & assign it to a variable
SFTP_pass=$(dx cat project-FQqXfYQ0Z0gqx7XG9Z2b4K43:congenica_SFTP_upload)

# cd into the output directory where sample are
dx cd output

# Upload required files into the cloud workstation 
dx download *markdup_Haplotyper.vcf.gz
dx download *markdup.bam

# Expect allows interaction with the sftp terminal 
# set timeout -1 means the expect script will not time out 
# Spawn runs a command
# use sshpass to pass -p (password for sftp)
# It waits to see expected return in the temrinal 
# Then sends the response 
/usr/bin/expect << EOF
    set timeout -1
    spawn sshpass -p $SFTP_pass sftp GSTT@eu-sftp.congenica.com
    expect "sftp>"
    send -- "put *.bam\r"
    expect "sftp>"
    send -- "put *vcf.gz\r"
    expect "sftp>"   
    send -- "exit\r"
EOF

# Exit the bash script
exit 0
