#!/bin/bash

# Check or create backup directory
if [ -d backup ]; then
    echo "Backup directory exists"
else
    mkdir backup
fi

home=`readlink -f ~`

for file in *
do
#    if [ -d $file ]; then
#	continue
    if [[ $file =~ install || $file =~ readme || $file =~ README || $file =~ backup ]]; then
	continue
    fi
    link_name="$home/.$file"
    target=`readlink -f $file`
    # Backup files if they exist
    if [ -e $link_name ]; then
	#cp $link_name ~/.dotfiles/backup
	echo "Copy $link_name to backup"
    fi
    #ln -ns $target $link_name
    echo "Filename $target linked from $link_name" 
done


exit
# Copy files
cp ~/.dotfiles/user/.location ~/.location
