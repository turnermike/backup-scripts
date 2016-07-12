#! /bin/sh

echo '=================================='
echo $(date)
echo '=================================='

# variables
FTP_USER_PASS="BackupsUser:K#\$hdRe2%344X_s"                    # FTP Username:Password
FTP_PORT="236"                                                  # FTP Port
SOURCE_DIR="/var/www/vhosts/giveusoneperiod.ca/httpdocs"        # Source path on server. The content to backup.
DESTINATION_DIR="giveusoneperiod.ca"                            # Destination path on remote server. The backup location.
MYSQL_HOST="localhost"
MYSQL_USER="giveusonep"
MYSQL_PASSWORD="Jif#x327"
MYSQL_DATABASE="giveusoneperiod_website"
DATE_TIME=$(date +%Y-%m-%d_%H-%M-%S)

echo '-- change into source directory'
cd $SOURCE_DIR

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

echo ''