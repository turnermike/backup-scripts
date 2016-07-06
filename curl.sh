#! /bin/sh

echo '=================================='
echo $(date)
echo '=================================='

echo '-- change into user_generated directory'
cd /var/www/vhosts/ristaging.ca/contest-templates.ristaging.ca/library/images/user_generated

echo '-- find and copy files to server'
# find . -type f -exec curl --user 'EBNOBackups:H@3f&$fh%ef' --ftp-create-dirs -T {} ftp://216.86.147.25:234/images/{} \;
find . -type f -exec curl --user 'RITemplatesBackups:P@#$HNhdu$45hd' --ftp-create-dirs -T {} ftp://216.86.147.25:235/images/{} \;

echo ''
