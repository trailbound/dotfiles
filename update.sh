#!/bin/bash

# Finds each submodule directory and updates it recursively, but individually. This
# allows a single submodule to fail update without causing future submodules to fail
# update. If you wish to remove a submodule, add "-not -name 'dir_name*'" to the
# find command.
find emacs.d/vendor/* -maxdepth 0 -type d -exec git submodule update --init --recursive {} \;
