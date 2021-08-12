#!/usr/bin/bash -d
set -exo pipefail

# Install required programs , to move to .json
sudo apt-get -y install sshpass=1.05-1
sudo apt-get -y install expect=5.45-7

# Gathers the public SSH host key of the Congenica SFTP
ssh-keyscan eu-sftp.congenica.com >> /root/.ssh/known_hosts

# Get password for SFTP & assign it to a variable
SFTP_pass=$(dx cat project-FQqXfYQ0Z0gqx7XG9Z2b4K43:congenica_SFTP_upload)

# cd into the output directory where sample are
dx cd output

# Download input bams and vcfs, to pull from json 

dx download project-G3jf40Q0p3jg19yfKjX2j76Q:file-G3jf6v00p3jfJ7y709Gxp9JF
dx download project-G3jf40Q0p3jg19yfKjX2j76Q:file-Fqyv9z006v3b9BvZF7fv87JK

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
