#!bin/bash

source ./common.sh
check_root

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Adding Mongo repo"

dnf install mongodb-org -y &>>$LOG_FILE
VALIDATE $? "installing MongoDB"

systemctl enable mongod &>>$LOG_FILE
VALIDATE $? "enabling mongoDB"

systemctl start mongod  &>>$LOG_FILE
VALIDATE $? "starting mongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Allowing remote connections to mongod"

systemctl restart mongod
VALIDATE $? "Restarted mongodb"