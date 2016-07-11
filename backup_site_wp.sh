#! /bin/sh

# crontab example - first day of each week at 5 am
# 0 5 * * 1 /bin/sh  /var/www/vhosts/domain.com/httpdocs/.backup/backup_site.sh  >> /var/www/vhosts/domain.com/httpdocs/.backup/cron.log 2>&1

echo '=================================='
echo $(date)
echo '=================================='

# variables
FTP_USER_PASS="BackupsUser:K#\$hdRe2%344X_s"                # FTP Username:Password
FTP_PORT="236"                                              # FTP Port
PUBLIC_SOURCE_DIR="/var/www/vhosts/domain.com/httpdocs"     # Path to public directory (httpdocs/public_html)
DESTINATION_DIR="domainname.com"                            # Destination path on remote server. The backup location.
MYSQL_HOST="localhost"                                      # MySQL host
MYSQL_USER="username"                                       # MySQL user
MYSQL_PASSWORD="password"                                   # MySQL password
MYSQL_DATABASE="database_name"                              # MySQL database name
DATE_TIME=$(date +%Y-%m-%d_%H-%M-%S)                        # Date/time stamp used for file names

echo '-- change into public directory'
cd $PUBLIC_SOURCE_DIR

echo '-- dump english the database'
mysqldump -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE_EN > $MYSQL_DATABASE_EN'_'$DATE_TIME'.sql'

echo '-- upload the english database dump'
find $MYSQL_DATABASE_EN'_'$DATE_TIME'.sql' -exec curl -u $FTP_USER_PASS --ftp-create-dirs -T {} ftp://216.86.147.25:$FTP_PORT/$DESTINATION_DIR/database/{} \;

echo '-- delete the english dump file'
rm $MYSQL_DATABASE_EN'_'$DATE_TIME'.sql'

echo '-- find and copy public (httpdocs) files to server'
find . -type f -exec curl -u $FTP_USER_PASS --ftp-create-dirs -T {} ftp://216.86.147.25:$FTP_PORT/$DESTINATION_DIR/httpdocs/{} \;

echo ''