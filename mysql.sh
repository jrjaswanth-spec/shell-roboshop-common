#!bin/bash

source ./common.sh
check_root

dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "installing mysql"
systemctl enable mysqld &>>$LOG_FILE
VALIDATE $? "enabling mysql"
systemctl start mysqld &>>$LOG_FILE
VALIDATE $? "starting mysql"  

mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOG_FILE
VALIDATE $? "setting root pass"