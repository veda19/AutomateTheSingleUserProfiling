#!/bin/sh
#Env Setup
path=$1
hostname=$2
tag=$3
transactionName=$4
appdNeeded=$5
controllerAccessKey=$6
dbServer=$7
#scp $path/MirthResults.ear root@hostname:/tmp/
#echo ear file copied to VM successfully
#ssh root@hostname "echo login  into VM is successfull;
#rm -rf /root/deploy;
#mkdir /root/deploy;
#echo "AS_ADMIN_password=adminadmin" > /root/deploy/password.txt;
#/opt/mirthresults/payara41/glassfish/bin/asadmin undeploy MirthResults;
#service mirth-mirthresults restart;
#chown mirth:mirth /root/deploy/*;
#/opt/mirthresults/payara41/glassfish/bin/asadmin deploy --force=true /tmp/MirthResults.ear"
#Triggering the feature
if [ "$appdNeeded" = "NEW_APPD" ]
then
  sh ./setupAppd.sh $hostname $dbServer $appdNeeded $controllerAccessKey;
else
  echo "You have chosen not Setup AppD, hence skipping it ......"
  sleep 2s;
  echo;
fi
echo "Initiating the Feature File Execution"
# Path to Automation Repository
cd 	/d/mirth/mirth_products_automation
if [ -d Report ]; then echo "Report directory exist"; else mkdir -p Report; fi
REPORT_PATH=/d/mirth/mirth_products_automation
echo "Report path is => "$REPORT_PATH
rm -rf Reportpath.txt
url=$hostname
api_url=https:\/\/$hostname:11443\/results\/api\/v2//
appliance=$hostname/
#gsed -i "s|MirthAutomationSuitePathMac.*|MirthAutomationSuitePathMac=$REPORT_PATH|g" src/main/resources/ControllerConfig.properties
#mvn clean compile
#sudo cp -rpf src/main/java/com/mirth/application/version2/results/testdata target/classes/com/mirth/application/version2/results/
#mvn test
for i in 1 4
do
  mvn test -Dcucumber.options="--tags $tag"
done
#mvn test -Dcucumber.options="--plugin pretty --plugin html:target/cucumber-html-report --plugin json:target/cucumber.json --plugin pretty:target/cucumber-pretty.txt --plugin usage:target/cucumber-usage.json --plugin com.cucumber.listener.ExtentCucumberFormatter:target/cucumber-reports/report.html --plugin com.epam.reportportal.cucumber.ScenarioReporter --tags $tag"
sleep 2
if [ -d cucumber-reports ]; then echo "Report directory exist"; else mkdir -p cucumber-reports; fi
cp -rpf target/cucumber* cucumber-reports/
cp -rpf target/extendedReport cucumber-reports/
CURRENT_DATE=$(date +'%m-%d-%Y-%H-%M')
mkdir -p $CURRENT_DATE
cp -rpf cucumber-reports $CURRENT_DATE/
echo "Execution Ended at =>"$CURRENT_DATE
sh /d/fetchFromAppD.sh $transactionName
