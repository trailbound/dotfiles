#!/bin/bash

# Check or create backup directory
if [ -d backup ]; then
    echo "Backup directory exists"
else
    mkdir backup
fi

home="~"

for file in *
do
    if [ -d $file ]; then
	continue
    elif [[ $file =~ install || $file =~ readme || $file =~ README ]]; then
	continue
    fi
    link_name="~/.$file"
    #ln -ns $file $link_name
    echo "Filename $file linked from $link_name" 
done


exit
# Copy files
cp ~/.env-config/user/.location ~/.location

if [ -e ~/.bash_profile ]; then
    cp ~/.bash_profile ~/.env-config/backup
    rm -f ~/.bash_profile
fi
ln -s ~/.env-config/.bash_profile ~/.bash_profile

if [ -e ~/.bashrc ]; then
    cp ~/.bashrc ~/.env-config/backup
    rm -f ~/.bashrc
fi
ln -s ~/.env-config/.bashrc ~/.bashrc

if [ -e ~/.emacs ]; then
    cp ~/.emacs ~/.env-config/backup
    rm -f ~/.emacs
fi
ln -s ~/.env-config/.emacs ~/.emacs

if [ -e ~/.Xdefaults ]; then
    cp ~/.Xdefaults ~/.env-config/backup
    rm -f ~/.Xdefaults
fi
ln -s ~/.env-config/.Xdefaults ~/.Xdefaults

if [ -e ~/.dir_colors ]; then
    cp ~/.dir_colors ~/.env-config/backup
    rm -f ~/.dir_colors
fi
ln -s ~/.env-config/.dir_colors ~/.dir_colors
