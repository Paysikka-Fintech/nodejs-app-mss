#!/bin/bash

#_Change_Working_Directory
cd /home/ubuntu/server

#sudo pm2 start server.js --watch
pm2 start server.js --watch
