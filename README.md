dnanexus_WES_Cognenica_SFTP_upload v0.1

A bash script has been created to undertake the same process this app will, whilst it is being developed into an app 
Invoke a cloud workstation, replacing X in imax_session_length, based on the number of samples you have to transfer with this command, to pull the WES_Congenica_SFTP_upload bash script (dx run app-cloud_workstation -ifids=project-ByfFPz00jy1fk6PjpZ95F27J:file-G4BV7jj0p3jVJJ2KBzGqpKy3 -imax_session_length=Xh --ssh) it can also be found in 001_ToolsReferenceData/Apps  in MokaGuys DNANexus account 

The bash script should be run from within the DNANexus folder you wish to upload 
The bash script:
1) Downloads required pacakges 
2) Uses ssh-keyscan gathers the public SSH host key of the Congenica SFTP
3) Downlaods required keys and files 
4) Uses expext to run the sshpass command to connect to the SFTP
5) Then puts in the VCFs and BAMs and then exits the SFTP


What does this app do?

This app will upload VCFs & BAMs from WES runs to the Congenica SFTP to be inputted into Congenic 

What are typical use cases for this app?

After quality checks of a WES run have been completed, this app will be run to upload the samples to Congenica 

What data are required for this app to run?



How does this app work?




This app was made by Viapath Genome Informatics
