#!/usr/bin/env bash
accountAccesskey=$2
ssh root@$1 "
sed -i 's/<controller-host><\/controller-host>/<controller-host>nextgenhealthcare-nonprod.saas.appdynamics.com<\/controller-host>/g' '/opt/appDynamics/DBAgent/conf/controller-info.xml';
sed -i 's/<controller-port><\/controller-port>/<controller-port>443<\/controller-port>/g' '/opt/appDynamics/DBAgent/conf/controller-info.xml';
sed -i 's/<application-name><\/application-name>/<application-name>MR<\/application-name>/g' '/opt/appDynamics/DBAgent/conf/controller-info.xml';
sed -i 's/<controller-ssl-enabled>false<\/controller-ssl-enabled>/<controller-ssl-enabled>true<\/controller-ssl-enabled>/g' '/opt/appDynamics/DBAgent/conf/controller-info.xml';
sed -i 's/<controller-ssl-enabled><\/controller-ssl-enabled>/<controller-ssl-enabled>true<\/controller-ssl-enabled>/g' '/opt/appDynamics/DBAgent/conf/controller-info.xml';
sed -i 's/<account-name><\/account-name>/<account-name>nextgenhealthcare-nonprod<\/account-name>/g' '/opt/appDynamics/DBAgent/conf/controller-info.xml';
sed -i 's/<account-access-key><\/account-access-key>/<account-access-key>$accountAccesskey<\/account-access-key>/g' '/opt/appDynamics/DBAgent/conf/controller-info.xml';
"

echo "Updated /opt/appDynamics/DBAgent/conf/controller-info.xml"
