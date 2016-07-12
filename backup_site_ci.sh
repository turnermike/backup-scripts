#! /bin/sh

# crontab example - first day of each week at 5 am
# 0 6 * * 2 /bin/sh  /var/www/vhosts/hydrosilkhotel.ca/.backup/backup_site_ci.sh  >> /var/www/vhosts/hydrosilkhotel.ca/.backup/cron.log 2>&1

echo '=================================='
echo $(date)
echo '=================================='

# variables
FTP_USER_PASS="BackupsUser:K#\$hdRe2%344X_s"                                    # FTP Username:Password
FTP_PORT="236"                                                                  # FTP Port
PUBLIC_SOURCE_DIR="/var/www/vhosts/hydrosilkhotel.ca/httpdocs"                  # Path to public directory (httpdocs/public_html)
CI_SOURCE_DIR="/var/www/vhosts/hydrosilkhotel.ca/hydrosilkhotel-codeigniter"    # Path to code igniter directory
DESTINATION_DIR="hydrosilkhotel.ca"                                             # Destination path on remote server. The backup location.
MYSQL_HOST="localhost"                                                          # MySQL host
MYSQL_USER="hydrosilk"                                                          # MySQL user
MYSQL_PASSWORD="Zoqv3%70"                                                       # MySQL password
MYSQL_DATABASE="hydrosilkhotel_website"                                         # MySQL database name
DATE_TIME=$(date +%Y-%m-%d_%H-%M-%S)                                            # Date/time stamp used for file names

echo '-- change into public directory'
cd $PUBLIC_SOURCE_DIR

echo '-- dump the database'
mysqldump -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE > $MYSQL_DATABASE'_'$DATE_TIME'.sql'

echo '-- upload the database dump'
find $MYSQL_DATABASE'_'$DATE_TIME'.sql' -exec curl -u $FTP_USER_PASS --ftp-create-dirs -T {} ftp://216.86.147.25:$FTP_PORT/$DESTINATION_DIR/database/{} \;

echo '-- delete the dump file'
rm $MYSQL_DATABASE'_'$DATE_TIME'.sql'

echo '-- zipping the public/httpdocs directory'
zip -rq $PUBLIC_SOURCE_DIR/.backup/httpdocs.zip ./*
echo '-- changing into codeigniter directory'
cd $CI_SOURCE_DIR
echo '-- zipping the codeigniter directory'
find . -type f -exec zip -rq $PUBLIC_SOURCE_DIR/.backup/codeigniter.zip ./* {} \;

echo '-- changing into httpdocs/.backup directory'
cd $PUBLIC_SOURCE_DIR/.backup
echo '-- copy the public/httpdocs zip to server'
find httpdocs.zip -type f -exec curl -u $FTP_USER_PASS --ftp-create-dirs -T {} ftp://216.86.147.25:$FTP_PORT/$DESTINATION_DIR/{} \;
echo '-- copy the codeigniter zip to server'
find codeigniter.zip -type f -exec curl -u $FTP_USER_PASS --ftp-create-dirs -T {} ftp://216.86.147.25:$FTP_PORT/$DESTINATION_DIR/{} \;

echo '-- removing the public/httpdocs zip file'
rm httpdocs.zip
echo '-- removing the codeigniter zip file'
rm codeigniter.zip

echo '=================================='
