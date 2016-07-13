#! /bin/sh

# crontab
# 15 * * * * /bin/sh  /var/www/vhosts/earlybirdornightowl.ca/httpdocs/.backup/user_gen_images.sh  >> /var/www/vhosts/earlybirdornightowl.ca/httpdocs/.backup/cron.log 2>&1

echo '=================================='
echo $(date)
echo '=================================='

# variables
FTP_USER_PASS="BackupsUser:K#\$hdRe2%344X_s"                                                # FTP Username:Password
FTP_PORT="236"                                                                              # FTP Port
SOURCE_DIR="/var/www/vhosts/earlybirdornightowl.ca/httpdocs/library/images/user_generated"  # Source path on server. The content to backup.
DESTINATION_DIR="earlybirdornightowl.ca-user-gen-images"                                    # Destination path on remote server. The backup location.


echo '-- change into user_generated directory'
cd $SOURCE_DIR

# echo '-- find and copy files to server'
# find . -type f -exec curl --user 'EBNOBackups:H@3f&$fh%ef' --ftp-create-dirs -T {} ftp://216.86.147.25:234/images/{} \;

echo '-- zip all files in user_generated directory'
find . -type f | zip -rq ./user_generated_images.zip ./* {} \;

echo '-- copy the zip file to server'
find user_generated_images.zip -type f -exec curl -u $FTP_USER_PASS --ftp-create-dirs -T {} ftp://216.86.147.25:$FTP_PORT/$DESTINATION_DIR/{} \;

echo '-- remove the zip file'
rm ./user_generated_images.zip

echo '-- all done'
echo ''
echo '=================================='
