# Shell Backup Scripts

These scripts are used for backing up data to a remote server.

## curl.sh

Uses Curl to FTP files to a remote server. First command will change into the local directory that you wish to back up. Second command will copy the files via FTP.

### Setup Steps

1. SSH into webserver.
2. Change into public directory.
3. Make a directory named '.backup'.
4. Copy curl.sh to this directory.
5. Open the file and modify the path in the first step to the directory that you wish to backup.

### Run It

You can execute the script by typing the folowing:

        ./curl.sh

Or, setup a Crontab to schedule the script execution automatically.


















