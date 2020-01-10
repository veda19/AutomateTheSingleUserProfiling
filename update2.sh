accountAccesskey=$2
ssh root@$1 "
sed -i 's/<controller-host><\/controller-host>/<controller-host>nextgenhealthcare-nonprod.saas.appdynamics.com<\/controller-host>/g' /opt/AppDynamics/appserver-agent/ver4.5.14.27768/conf/controller-info.xml;
sed -i 's/<controller-port><\/controller-port>/<controller-port>443<\/controller-port>/g' /opt/AppDynamics/appserver-agent/ver4.5.14.27768/conf/controller-info.xml;
sed -i 's/<application-name><\/application-name>/<application-name>MR<\/application-name>/g' /opt/AppDynamics/appserver-agent/ver4.5.14.27768/conf/controller-info.xml;
sed -i 's/<controller-ssl-enabled>false<\/controller-ssl-enabled>/<controller-ssl-enabled>true<\/controller-ssl-enabled>/g' /opt/AppDynamics/appserver-agent/ver4.5.14.27768/conf/controller-info.xml;
sed -i 's/<controller-ssl-enabled><\/controller-ssl-enabled>/<controller-ssl-enabled>true<\/controller-ssl-enabled>/g' /opt/AppDynamics/appserver-agent/ver4.5.14.27768/conf/controller-info.xml;
sed -i 's/<account-name><\/account-name>/<account-name>nextgenhealthcare-nonprod<\/account-name>/g' /opt/AppDynamics/appserver-agent/ver4.5.14.27768/conf/controller-info.xml;
sed -i 's/<account-access-key><\/account-access-key>/<account-access-key>$accountAccesskey<\/account-access-key>/g' /opt/AppDynamics/appserver-agent/ver4.5.14.27768/conf/controller-info.xml;
"

echo "Updated /opt/AppDynamics/appserver-agent/ver4.5.14.27768/conf/controller-info.xml"
