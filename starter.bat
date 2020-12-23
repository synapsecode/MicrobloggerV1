@echo off
cd MicroBloggerCore
start
cd ..
cd Microblogger
start
code .
cd ..
ngrok http localhost:5000