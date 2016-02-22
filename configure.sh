#!/bin/bash

SCRIPTPATH=$(dirname "$0")

# Read options (-p, -dbi, -db, -v for project id, instance name, db name and deployment version)
while getopts p:dbi:db:v: opts; do
   case ${opts} in
      p)    projectId=${OPTARG} ;;
      dbi)  sqlInstanceName=${OPTARG} ;;
      db)   dbName=${OPTARG} ;;
      v)    appVersion=${OPTARG} ;;
   esac
done

# Read values from input if not provided via options and provide suitable defaults
if [ -z "$projectId" ]; then
    echo Provide Google App Engine project ID:
    read projectId
fi
if [ -z "$projectId" ]; then
    echo Error: Required Project ID is empty
    exit 1
fi

if [ -z "$sqlInstanceName" ]; then
    echo "Provide Google Cloud SQL instance name [wordpress]:"
    read sqlInstanceName
fi
if [ -z "$sqlInstanceName" ]; then
    sqlInstanceName=wordpress
fi

if [ -z "$dbName" ]; then
    echo "Provide database name (leave empty to use instance name as a database name) [$sqlInstanceName]:"
    read dbName
fi
if [ -z "$dbName" ]; then
    dbName=${sqlInstanceName}
fi

if [ -z "$appVersion" ]; then
    echo Provide deployment app version [wp-1]:
    read appVersion
fi
if [ -z "$appVersion" ]; then
    appVersion=wp-1
fi


# Creating config files from defaults replacing default values
#
# your-project-id       → $projectId
# wordpress             → $sqlInstanceName
# wordpress_db          → $dbName
# wpfromstarterproject  → $appVersion

echo Configuring PROJECT ${projectId} VERSION ${appVersion}, DBNAME ${dbName} on GCSQL INSTANCE ${sqlInstanceName}

# Replace Project ID and create app.yaml
sed "s/your-project-id/$projectId/g" ${SCRIPTPATH}/app-default.yaml > ${SCRIPTPATH}/app.yaml

# Replace Project ID and Cloud SQL instance name and create wp-config.php
sed "s/your-project-id:wordpress/$projectId:$sqlInstanceName/g" ${SCRIPTPATH}/wp-config-default.php > ${SCRIPTPATH}/wp-config.php

# Replace App version in app.yaml
sed -i '' "s/wpfromstarterproject/$appVersion/g" ${SCRIPTPATH}/app.yaml
# Replace DB name in wp-config.php
sed -i '' "s/wordpress_db/$dbName/g" ${SCRIPTPATH}/wp-config.php

echo ...done!


# TODO: Replace AUTH_KEY, SECURE_AUTH_KEY, etc. declarations in wp-config.php with output from
# openssl rand -base64 42
# ↑ this should be done only once, not on every configure launch


# Creating local DB
#echo "Creating local database (if not exists)..."
#mysql -uroot -e "CREATE DATABASE IF NOT EXISTS \`${dbName}\`"

echo All Done!

echo "Don’t forget to launch"
echo "google_sql.py $projectId:$sqlInstanceName"
echo "to access Cloud SQL instance and create database there:"
echo "CREATE DATABASE IF NOT EXISTS $dbName;"

echo "To run configuration again in non-interactive mode, launch"
echo "sh configure.sh -p $projectId -dbi $sqlInstanceName -db $dbName -v $appVersion"

