#! /bin/sh

# crontab example - second day of each week at 4 am
# 0 4 * * 2 /bin/sh  /var/www/vhosts/worldvisiongiftsnews.ca/httpdocs/.backup/backup_site_wp.sh  >> /var/www/vhosts/worldvisiongiftsnews.ca/httpdocs/.backup/cron.log 2>&1

echo '=================================='
echo $(date)
echo '=================================='

# variables
FTP_USER_PASS="BackupsUser:K#\$hdRe2%344X_s"                    # FTP Username:Password
FTP_PORT="236"                                                  # FTP Port
SOURCE_DIR="/var/www/vhosts/worldvisiongiftsnews.ca/httpdocs"   # Path to public directory (httpdocs/public_html)
DESTINATION_DIR="worldvisiongiftsnews.ca"                       # Destination path on remote server. The backup location.
MYSQL_HOST="localhost"                                          # MySQL host
MYSQL_USER="wvgn_website"                                       # MySQL user
MYSQL_PASSWORD="*Qvgk476"                                       # MySQL password
MYSQL_DATABASE="wvgn_website"                                   # MySQL database name
DATE_TIME=$(date +%Y-%m-%d_%H-%M-%S)                            # Date/time stamp used for file names

echo '-- change into public directory'
cd $PUBLIC_SOURCE_DIR

echo '-- dump the database'
mysqldump -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE > $MYSQL_DATABASE'_'$DATE_TIME'.sql'

echo '-- upload the database dump'
find $MYSQL_DATABASE'_'$DATE_TIME'.sql' -exec curl -u $FTP_USER_PASS --ftp-create-dirs -T {} ftp://216.86.147.25:$FTP_PORT/$DESTINATION_DIR/database/{} \;

echo '-- delete the dump file'
rm $MYSQL_DATABASE'_'$DATE_TIME'.sql'

echo '-- zip the httpdocs directory'
find . -type f -exec zip -rq $SOURCE_DIR/.backup/httpdocs.zip $SOURCE_DIR/* {} \;

echo '-- change into httpdocs/.backup directory'
cd $SOURCE_DIR/.backup/

echo '-- copy httpdocs zip to server'
find httpdocs.zip -type f -exec curl -u $FTP_USER_PASS --ftp-create-dirs -T {} ftp://216.86.147.25:$FTP_PORT/$DESTINATION_DIR/{} \;

echo '-- removing httpdocs directory'
rm $SOURCE_DIR/.backup/httpdocs.zip

echo '-- all done'
echo ''
echo '=================================='