#!bin/bash

source ./common.sh
check_root


cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo  &>>$LOG_FILE
VALIDATE $? "adding rabbitmq repo"

dnf install rabbitmq-server -y  &>>$LOG_FILE
VALIDATE $? "installinf rabbitmq"
systemctl enable rabbitmq-server  &>>$LOG_FILE
VALIDATE $? "enabling rabbitmq"
systemctl start rabbitmq-server  &>>$LOG_FILE
VALIDATE $? "starting rabbitmq"

rabbitmqctl add_user roboshop roboshop123
VALIDATE $? "adding user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>$LOG_FILE
VALIDATE $? "setting up permissions"