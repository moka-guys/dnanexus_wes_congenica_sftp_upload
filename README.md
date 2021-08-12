 # dnanexus_WES_Cognenica_SFTP_upload v0.1

A bash script has been created to undertake the same process this app will, whilst it is being developed into an app: 
1) dx select the WES run you wish to upload
2) Invoke a cloud workstation (replacing X in -imax_session_length) with *dx run app-cloud_workstation -ifids=project-ByfFPz00jy1fk6PjpZ95F27J:file-G4BV7jj0p3jVJJ2KBzGqpKy3 -imax_session_length=Xh --ssh* to pull the bash script into the workstation
3) Run the bash script 

The bash script should be run from within the root for of the WES run you wish to upload 
The bash script:
1) Downloads required packages 
2) Uses ssh-keyscan gathers the SSH host key of the Congenica SFTP
3) Downloads required keys and files 
4) Uses the expect package to run the sshpass command to connect to the SFTP
5) Then puts in the VCFs and BAMs and then exits the SFTP



## What does this app do?

This app will upload VCFs & BAMs from WES runs to the Congenica SFTP to be inputted into Congenic 

## What are typical use cases for this app?

After quality checks of a WES run have been completed, this app will be run to upload the samples to Congenica 

## What data are required for this app to run?



## How does this app work?




## This app was made by Viapath Genome Informatics
