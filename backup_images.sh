#! /bin/sh

# crontab
# 15 * * * * /bin/sh  /var/www/vhosts/earlybirdornightowl.ca/httpdocs/.backup/user_gen_images.sh  >> /var/www/vhosts/earlybirdornightowl.ca/httpdocs/.backup/cron.log 2>&1

echo '=================================='
echo $(date)
echo '=================================='

echo '-- change into user_generated directory'
cd /var/www/vhosts/earlybirdornightowl.ca/httpdocs/library/images/user_generated

# echo '-- find and copy files to server'
# find . -type f -exec curl --user 'EBNOBackups:H@3f&$fh%ef' --ftp-create-dirs -T {} ftp://216.86.147.25:234/images/{} \;

echo '-- zip all files in user_generated directory'
find . -type f -exec zip -rq ./user_generated_images.zip ./* {} \;

echo '-- copy the zip file to server'
find user_generated_images.zip -type f -exec curl -u $FTP_USER_PASS --ftp-create-dirs -T {} ftp://216.86.147.25:$FTP_PORT/$DESTINATION_DIR/{} \;

echo '-- remove the zip file'
rm ./user_generated_images.zip

echo '=================================='
