#! /bin/sh

echo '-- change into user_generated directory'
cd /var/www/vhosts/ristaging.ca/contest-templates.ristaging.ca/library/images/user_generated

echo '-- find and copy files to server'
find . -type f -exec curl --user 'EBNOBackups:H@3f&$fh%ef' --ftp-create-dirs -T {} ftp://216.86.147.25:234/images/{} \;