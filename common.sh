#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$( echo $0 | cut -d. -f1 )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

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