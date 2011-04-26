#!/bin/bash
# Windows doesn't like symlinks, so we can't use them.

# Check or create backup directory
if [ -d ~/.env-config/backup ]; then
    echo "Backup directory exists"
else
    mkdir ~/.env-config/backup
fi

# Copy files
cp ~/.env-config/user/.location ~/.location

if [ -e ~/.bash_profile ]; then
    cp ~/.bash_profile ~/.env-config/backup
    rm -f ~/.bash_profile
fi
cp ~/.env-config/.bash_profile ~/.bash_profile

if [ -e ~/.bashrc ]; then
    cp ~/.bashrc ~/.env-config/backup
    rm -f ~/.bashrc
fi
cp ~/.env-config/.bashrc ~/.bashrc

if [ -e ~/.emacs ]; then
    cp ~/.emacs ~/.env-config/backup
    rm -f ~/.emacs
fi
cp ~/.env-config/.emacs ~/.emacs

if [ -e ~/.Xdefaults ]; then
    cp ~/.Xdefaults ~/.env-config/backup
    rm -f ~/.Xdefaults
fi
cp ~/.env-config/.Xdefaults ~/.Xdefaults

if [ -e ~/.dir_colors ]; then
    cp ~/.dir_colors ~/.env-config/backup
    rm -f ~/.dir_colors
fi
cp ~/.env-config/.dir_colors ~/.dir_colors
