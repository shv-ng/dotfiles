#!/bin/bash

FTP_DIR="/mnt/my_ftp/"
if [ -d "$FTP_DIR" ]; then
  sudo mkdir -p $FTP_DIR
  sudo chmod 777 $FTP_DIR
fi

mounted=false
IP="$(ip route | rg 'default .* dev' -o | rg '192\.168\.\d+\.\d+' -o)"

curlftpfs "admin:ayush@$IP:2121" $FTP_DIR 2>&1 && mounted=true 

if [ "$mounted" = true ]; then
  tmux_sessionizer $FTP_DIR
fi 
