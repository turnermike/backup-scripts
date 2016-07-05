# Shell Backup Scripts

These scripts are used for backing up data to a remote server. See down below for steps to setup a new FTP user on Windows Server 2012.

## curl.sh

Uses Curl to FTP files to a remote server. First command will change into the local directory that you wish to back up. Second command will copy the files via FTP.

### Setup Steps

1. SSH into webserver.
2. Change into public directory.
3. Make a directory named '.backup'.
4. Copy curl.sh to this directory.
5. Open the file and modify the path in the first step to the directory that you wish to backup. Then exit and save the file.
6. Grant execute permissions, use the following command:
    
    chmod +x curl.sh

### Run It

You can execute the script by typing the folowing:

        ./curl.sh

Or, setup a Crontab to schedule the script execution automatically.

# New FTP User on Windows Server 2012

In order to FTP backups to our Windows server, we will need to create a new FTP account for each site and directory for saving backups. This will keep our backups organized on the remote server.

## Create a New Backup Directory

1. Login to the server via RDC.
2. Open Windows Explorer and navigate to `C:\inetpub\ftproot`.
3. Create a new folder for your backups. Try to follow any existing naming conventions. For this example, we will name it 'RITemplatesBackups'.

## Create a New User

1. Open Windows Control Panel.
2. Select User Accounts.
3. Click Manage Another Account.
4. Click Add a user account.
5. Enter a user name and password. For this example we will use 'RITemplatesBackups' as the user name.
6. Click Next, and then Finish. You should now see your new user listed as a 'Local Account'.

## Assign Permissions to New User for New Directory

1. Open Windows Explorer.
2. Navigate to `C:\inetpub\ftproot`.
3. Right click on your new folder (RITemplatesBackups) and select Properties.
4. Select the Security tab.
5. Click the Edit button.
6. Click the Add button.
7. Type your new user name in the 'Enter the object names...' (RITemmplatesBackups), and then click Check Names. Your name should be underlined if successful.
8. Click OK.
9. Allow for Modify, Read & execute, List folder contents, Read and Write.
10. Click Apply and then OK.
11. Click OK again to close Properties.

## Create a New FTP Site in IIS

1. Open IIS.
2. Expand your server and then Sites from the left tree menu.
3. Right click on Sites and select Add FTP Site...
4. Enter a name, for this example we will use 'RITemplatesBackups'.
5. For the Content Directory field, browse to the folder we previously created `C:\inetpub\ftproot\RITemplatesBackups`.
6. Click Next.
7. Select the appropriate IP address.
8. Enter a port number that is not already in use.
9. Select Allow SSL and choose the appropriate certificate.
10. Click Next.
11. Select Basic for Authentication and do not check Anonymous.
12. For Allow Access to, select Specified Users.
13. Enter the user name you just created (RITemplatesBackups)
14. Select Read and Write for Permissions.
15. Your new FTP site should now be running. There should be no stop icon above it in the left menu.

## Add New Firewall Rule

1. Open Windows Firewall.
2. Select Inbound Rules from the left menu.
3. Select New Rule... from the right menu.
4. Select Port and click Next.
5. Select TCP and Specific local ports. Enter the FTP port used in the previous step.
6. Click Next.
7. Select Allow the connection.
8. Leave all 3 options selected. Click Next.
9. Enter a Name. For this example use 'RITemplatesBackups'.
10. Click Finish.

## Restart the FTP Service

1. Open Server Manager.
2. Select Tools > Services from the top right menu.
3. Locate Microsoft FTP Services and select it.
4. Click Rstart from the left menu.




















