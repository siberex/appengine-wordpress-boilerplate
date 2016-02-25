#!/bin/bash

SCRIPTPATH=$(dirname "$0")


# Read options (-p, -i, -d, -v for project id, sql instance name, db name and deployment version)
while getopts p:i:d:v: opts; do
    case ${opts} in
        p)  projectId=${OPTARG} ;;
        i)  sqlInstanceName=${OPTARG} ;;
        d)  dbName=${OPTARG} ;;
        v)  appVersion=${OPTARG} ;;
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


getRandomString() {
    #head -c 33 /dev/random | base64
    base64 /dev/urandom | tr -d '/+' | dd bs=42 count=1 2>/dev/null
}

AUTHKEYS=${SCRIPTPATH}/authkeys
if [ ! -f ${AUTHKEYS} ]; then
    echo "## Creating authkeys file"
    sed "s/AUTH_KEY_VALUE/$(getRandomString)/g" ${AUTHKEYS}.template > ${AUTHKEYS}
    sed -i '' "s/SECURE_AUTHKEY_VALUE/$(getRandomString)/g" ${AUTHKEYS}
    sed -i '' "s/LOGGED_IN_KEY_VALUE/$(getRandomString)/g" ${AUTHKEYS}
    sed -i '' "s/NONCE_KEY_VALUE/$(getRandomString)/g" ${AUTHKEYS}
    sed -i '' "s/AUTH_SALT_VALUE/$(getRandomString)/g" ${AUTHKEYS}
    sed -i '' "s/SECURE_AUTHSALT_VALUE/$(getRandomString)/g" ${AUTHKEYS}
    sed -i '' "s/LOGGED_IN_SALT_VALUE/$(getRandomString)/g" ${AUTHKEYS}
    sed -i '' "s/NONCE_SALT_VALUE/$(getRandomString)/g" ${AUTHKEYS}
    echo "...done!"
fi


echo "## Creating app.yaml file"

APPYAML=${SCRIPTPATH}/app.yaml

# Replace Project ID and create app.yaml
sed "s/your-project-id/$projectId/g" ${SCRIPTPATH}/app-default.yaml > ${APPYAML}

# Replace App version
sed -i '' "s/wpfromstarterproject/$appVersion/g" ${APPYAML}

# Replace Project ID and Cloud SQL instance name
sed -i '' "s/your-project-id:wordpress/$projectId:$sqlInstanceName/g" ${APPYAML}

# Replace DB name
sed -i '' "s/wordpress_db/$dbName/g" ${APPYAML}

# Replace auth keys placeholder
PLACEHOLDER='# Replace this line with authkeys file contents'
#sed -i '' "s/${PLACEHOLDER}/$(cat ${AUTHKEYS})/g" ${APPYAML}

sed -i '' "/${PLACEHOLDER}/{
    r ${AUTHKEYS}
    d
}" ${APPYAML}

echo "...done!"


# Creating local DB
#echo "Creating local database (if not exists)..."
#mysql -uroot -e "CREATE DATABASE IF NOT EXISTS \`${dbName}\`"

echo "All Done!"

echo "Don’t forget to launch"
echo "# google_sql.py $projectId:$sqlInstanceName"
echo "to access Cloud SQL instance and create database there:"
echo "> CREATE DATABASE IF NOT EXISTS $dbName;"

echo "To run configuration again in non-interactive mode, launch"
echo "# sh configure.sh -p $projectId -i $sqlInstanceName -d $dbName -v $appVersion"




