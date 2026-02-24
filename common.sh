#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$( echo $0 | cut -d. -f1 )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
MONGODB_HOST=mongodb.jrdaws.life
SCRIPT_DIR=$PWD

mkdir -p $LOGS_FOLDER
echo "script started executed at: $( "date" )" &>>$LOG_FILE

check_root(){
if [ $USERID -ne 0 ]
then
     echo "ERROR: please run this script with root privelage"
     exit 1
fi
}


VALIDATE(){
        if [ $1 -ne 0 ] 
    then
         echo -e "$2...$R FAILURE $N"
         exit 1
    else
         echo -e "$2....$G SUCCESS $N"
    fi     
}
nodejs_setup(){
     dnf module disable nodejs -y &>>$LOG_FILE
     VALIDATE $? "Disabling NodeJs" 


     dnf module enable nodejs:20 -y &>>$LOG_FILE
     VALIDATE $? "enabling nodejs:20" 

     dnf install nodejs -y &>>$LOG_FILE
     VALIDATE $? "installing nodejs" 

     npm install &>>$LOG_FILE
     VALIDATE $? "install dependencies"
}

app_setup(){

     mkdir -p /app 
     VALIDATE $? "creating app directory" 
     curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip  &>>$LOG_FILE
     VALIDATE $? "Downloading $app_name application" 
     cd /app 
     VALIDATE $? "changing to app directory"
     rm -rf /app/*
     VALIDATE $? "removing existing code"
     unzip /tmp/$app_name.zip &>>$LOG_FILE
     VALIDATE $? "Unzip $app_name"

}
systemd_setup(){
cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service
VALIDATE $? "copy systemctl services"
systemctl daemon-reload
VALIDATE $? "daemon reload"
systemctl enable $app_name &>>$LOG_FILE
VALIDATE $? "enable $app_name"
systemctl start $app_name
VALIDATE $? "start $app_name"
}

app_restart(){
    systemctl restart $app_name
    VALIDATE $? "restarted $app_name"
}  