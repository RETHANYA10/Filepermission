#!/bin/bash

echo "Creating directory mydir"
sudo mkdir -p mydir

echo "Changing permission"
sudo chmod 755 mydir

echo "Directory details:"
ls -ld mydir
