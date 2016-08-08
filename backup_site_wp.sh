#! /bin/sh

# crontab example - second day of each week at 5 am
# 0 5 * * 2 /bin/sh  /var/www/vhosts/6deg.ca/httpdocs/.backup/backup_site_wp.sh  >> /var/www/vhosts/6deg.ca/httpdocs/.backup/cron.log 2>&1

echo '=================================='
echo $(date)
echo '=================================='

# variables
FTP_USER_PASS="BackupsUser:K#\$hdRe2%344X_s"            # FTP Username:Password
FTP_PORT="236"                                          # FTP Port
PUBLIC_SOURCE_DIR="/var/www/vhosts/6deg.ca/httpdocs"    # Path to public directory (httpdocs/public_html)
DESTINATION_DIR="6deg.ca"                               # Destination path on remote server. The backup location.
MYSQL_HOST="localhost"                                  # MySQL host
MYSQL_USER="6deg_website"                               # MySQL user
MYSQL_PASSWORD="gtf43D*1"                               # MySQL password
MYSQL_DATABASE="6deg_website"                           # MySQL database name
DATE_TIME=$(date +%Y-%m-%d_%H-%M-%S)                    # Date/time stamp used for file names

echo '-- change into public directory'
cd $PUBLIC_SOURCE_DIR

echo '-- dump the database'
mysqldump -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE > $MYSQL_DATABASE'_'$DATE_TIME'.sql'

echo '-- upload the database dump'
find $MYSQL_DATABASE'_'$DATE_TIME'.sql' -exec curl -u $FTP_USER_PASS --ftp-create-dirs -T {} ftp://216.86.147.25:$FTP_PORT/$DESTINATION_DIR/database/{} \;

echo '-- delete the dump file'
rm $MYSQL_DATABASE'_'$DATE_TIME'.sql'

echo '-- zip the httpdocs directory'
find . -type f -exec zip -rq $PUBLIC_SOURCE_DIR/.backup/httpdocs.zip $PUBLIC_SOURCE_DIR/* {} \;

echo '-- change into httpdocs/.backup directory'
cd $PUBLIC_SOURCE_DIR/.backup/

echo '-- copy httpdocs zip to server'
find httpdocs.zip -type f -exec curl -u $FTP_USER_PASS --ftp-create-dirs -T {} ftp://216.86.147.25:$FTP_PORT/$DESTINATION_DIR/{} \;

echo '-- removing httpdocs directory'
rm $PUBLIC_SOURCE_DIR/.backup/httpdocs.zip

echo '=================================='