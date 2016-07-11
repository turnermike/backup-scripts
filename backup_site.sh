#! /bin/sh

# crontab example - first day of each week at 5 am
# 0 5 * * 1 /bin/sh  /var/www/vhosts/ristaging.ca/contest-templates.ristaging.ca/.backup/backup_site.sh  >> /var/www/vhosts/ristaging.ca/contest-templates.ristaging.ca/.backup/cron.log 2>&1

echo '=================================='
echo $(date)
echo '=================================='

# variables
FTP_USER_PASS="BackupsUser:K#\$hdRe2%344X_s"                                        # FTP Username:Password
FTP_PORT="236"                                                                      # FTP Port
PUBLIC_SOURCE_DIR="/var/www/vhosts/ristaging.ca/contest-templates.ristaging.ca"     # Path to public directory (httpdocs/public_html)
CI_SOURCE_DIR="/var/www/vhosts/ristaging.ca/contest-templates-codeigniter"          # Path to code igniter directory
DESTINATION_DIR="contest-templates.ristaging.ca"                                    # Destination path on remote server. The backup location.
MYSQL_HOST="localhost"                                                              # MySQL host
MYSQL_USER="contest_tpl"                                                            # MySQL user
MYSQL_PASSWORD="Kgpc*401"                                                           # MySQL password
MYSQL_DATABASE="ristaging_contest_templates"                                        # MySQL database name
DATE_TIME=$(date +%Y-%m-%d_%H-%M-%S)                                                # Date/time stamp used for file names

echo '-- change into public directory'
cd $PUBLIC_SOURCE_DIR

echo '-- dump the database'
mysqldump -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE > $MYSQL_DATABASE'_'$DATE_TIME'.sql'

echo '-- upload the database dump'
find $MYSQL_DATABASE'_'$DATE_TIME'.sql' -exec curl -u $FTP_USER_PASS --ftp-create-dirs -T {} ftp://216.86.147.25:$FTP_PORT/$DESTINATION_DIR/database/{} \;

echo '-- delete the dump file'
rm $MYSQL_DATABASE'_'$DATE_TIME'.sql'

echo '-- find and copy public (httpdocs) files to server'
find . -type f -exec curl -u $FTP_USER_PASS --ftp-create-dirs -T {} ftp://216.86.147.25:$FTP_PORT/$DESTINATION_DIR/httpdocs/{} \;

echo '-- change into code igniter directory'
cd $CI_SOURCE_DIR

echo '-- find and copy code igniter files to server'
find . -type f -exec curl -u $FTP_USER_PASS --ftp-create-dirs -T {} ftp://216.86.147.25:$FTP_PORT/$DESTINATION_DIR/codeigniter/{} \;

echo ''