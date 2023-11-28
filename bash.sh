#!/bin/bash

# Database credentials
DB_USER="lab"
DB_PASSWORD="admin@123"
DB_NAME="lab24"

# S3 bucket details
S3_BUCKET="privateserver01-mysql-backup-files"
S3_PREFIX="backup/"

# Timestamp for backup file
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
BACKUP_FILE="backup_$TIMESTAMP.sql"

# MySQL dump command
mysqldump -u$DB_USER -p$DB_PASSWORD $DB_NAME > $BACKUP_FILE

# Check if mysqldump was successful
if [ $? -eq 0 ]; then
  echo "MySQL backup completed successfully."

  # Upload the backup to S3
  aws s3 cp $BACKUP_FILE s3://$S3_BUCKET/$S3_PREFIX$BACKUP_FILE

  # Check if upload was successful
  if [ $? -eq 0 ]; then
    echo "Backup uploaded to S3 successfully."
  else
    echo "Error: Failed to upload backup to S3."
  fi

  # Remove the local backup file
  rm $BACKUP_FILE
else
  echo "Error: MySQL backup failed."
fi
