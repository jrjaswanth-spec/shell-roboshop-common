#!?bin?bash

source ./common.sh
app_name=catalogue
check_root
app_setup
nodejs_setup
systemd_setup

id roboshop &>>$LOG_FILE
if [ $? -ne 0 ]; then
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
VALIDATE $? "creating system user" 
else
     echo -e "user already exist....$Y SKIPPING $N"
fi
 

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "copying mongo repo"
dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "installing mongodb client"

INDEX=$(mongosh mongodb.jrdaws.life --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')")
if [ $INDEX -le 0 ]; then
mongosh --host $MONGODB_HOST </app/db/master-data.js &>>$LOG_FILE
VALIDATE $? "Load $app_name products"
else
    echo -e "$app_name products already loaded...$Y SKIPPING $N"
fi
systemctl restart $app_name

app_restart