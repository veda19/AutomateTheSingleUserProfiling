#!/bin/sh
# Please copy the AppServerAgent-4.5.14.27768.zip file downloaded from the page
# https://confluence.nextgen.com/pages/viewpage.action?pageId=216703564 and copy to /opt/ if you are having a fresh installation of App Dynamics
# Two Paramers needed for this script
# The Parameters needed for this script are APPSERVER, DBSERVER, NEW_APPD (if Appdynamics isn't already installed), controller-conf-key
#                                                                OLD_APPD (otherwise)
appServer=$1
scp ./AppServerAgent-4.5.14.27768.zip root@$appServer:/opt/
ssh root@$appServer    "echo;
                       echo "Just reached insdide the VM"
                       echo;
                       sleep 2s;
                       echo "Removing if another agent has been installed already";
                       rm -rf /opt/appdy/;
                       rm -rf /opt/AppDynamics/;

                       sleep 2s;
                       if grep -q "Dorg.osgi.framework.bootdelegation=com.singularity.*" "/opt/mirthresults/glassfish3/glassfish/domains/domain1/config/domain.xml" -a
                          grep -q "Dappdynamics*" "/opt/mirthresults/glassfish3/glassfish/domains/domain1/config/domain.xml"
                       then
                         echo;
                         echo "jvm options needed for App Dynamics is already available in the doman.xml. Hereby skipping adding em again..";
                         echo;
                       else
                         /opt/mirthresults/glassfish3/glassfish/bin/asadmin create-jvm-options "-Dorg.osgi.framework.bootdelegation=com.singularity.*";
                         /opt/mirthresults/glassfish3/glassfish/bin/asadmin create-jvm-options \"-javaagent\:/opt/AppDynamics/appserver-agent/javaagent.jar\";
                         /opt/mirthresults/glassfish3/glassfish/bin/asadmin create-jvm-options "-Dappdynamics.agent.tierName=mrtier1";
                         /opt/mirthresults/glassfish3/glassfish/bin/asadmin create-jvm-options "-Dappdynamics.agent.nodeName=mrnode1";
                         /opt/mirthresults/glassfish3/glassfish/bin/asadmin create-jvm-options "-Dappdynamics.agent.uniqueHostId=mr";
                         echo;
                         echo "The needed jvm options are added to the domain.xml";
                         echo;
                       fi
                       sleep 2s;

                       if [ $3 == "NEW_APPD" ]
                       then
                         echo;
                         echo "Unzipping the agent to /opt/AppDynamics/appserver-agent/ since you have not already have the agent installed";
                         mkdir /opt/AppDynamics;
                         mkdir -p /opt/AppDynamics/appserver-agent;
                         chown -R mirth:mirth /opt/AppDynamics;
                         cd /opt/AppDynamics/appserver-agent;
                         mv /opt/AppServerAgent-4.5.14.27768.zip /opt/AppDynamics/appserver-agent;
                         unzip /opt/AppDynamics/appserver-agent/AppServerAgent-4.5.14.27768.zip;
                         echo "Agent Installed";
                       fi
                       sleep 2s;
                       chown -R mirth:mirth /opt/AppDynamics/;


                       #Updating the Controller Config File
                       controllerAccessKey=$4;
                       "
                       sh ./update.sh $appServer $controllerAccessKey
                       sh ./update2.sh $appServer $controllerAccessKey


ssh root@$appServer    "
                        echo;
                        echo "Removing osgi-cache and generated";
                        echo;
                        rm -rf /opt/mirthresults/glassfish3/glassfish/domains/domain1/osgi-cache/;
                        rm -rf /opt/mirthresults/glassfish3/glassfish/domains/domain1/generated/;

                        #Updating the OSGI Properties
                        sleep 2s;
                        if grep -q "singularity" "/opt/mirthresults/glassfish3/glassfish/config/osgi.properties"
                        then
                          echo;
                          echo "com.singularity, com.singularity.* already exists in the file osgi.properties, hence skipping adding the same...";
                          echo;
                        else
                          sed -i '0,/=\${eclipselink.bootdelegation},/ s/=\${eclipselink.bootdelegation},/=\${eclipselink.bootdelegation}, com.singularity,com.singularity.*,/' /opt/mirthresults/glassfish3/glassfish/config/osgi.properties;
                          sed -i '0,/=oracle.sql, oracle.sql.*/ s/=oracle.sql, oracle.sql.*/=oracle.sql, oracle.sql.*, com.singularity,com.singularity.*/' /opt/mirthresults/glassfish3/glassfish/config/osgi.properties;
                          echo;
                          echo "Added config in the file osgi.properties";
                          echo;
                        fi

                        sleep 2s;
                        echo;
                        echo "Restarting the domain for getting the changes effected.."
                        echo;

                        "
sleep 2s;
echo "AppD agent setup on the Application server has been successfull... ";
sleep 2s;


# Installing the Database Agent
echo;
dbUrl=$2;
echo "The Database server URL is '$dbUrl'";

# make sure the DB Agent is downloaded in the current folder or feel free to update the script as needed
scp ./db-agent-4.5.15.1486.zip root@$dbUrl:/opt/;

ssh root@$dbUrl    "echo "Inside the Database Server VM";
                    if [ $3 == "NEW_APPD" ]
                    then
                      mkdir /opt/appDynamics;
                      mkdir /opt/appDynamics/DBAgent;
                      cd /opt/appDynamics/DBAgent;
                      cp /opt/db-agent-4.5.15.1486.zip /opt/appDynamics/DBAgent/;
                      unzip db-agent-4.5.15.1486.zip;
                    fi
                    "

                    sh ./updateDB.sh $appServer $controllerAccessKey;

scp AppD-DBagent root@$dbUrl:/etc/init.d/

ssh root@$dbUrl "
                    chmod +x /etc/init.d/AppD-DBagent;
                    /etc/init.d/AppD-DBagent start

                    psql -U postgres -qAt -c \"CREATE ROLE db_agent WITH SUPERUSER CREATEDB CREATEROLE LOGIN ENCRYPTED PASSWORD 'h0tc0ff33';\"
                    echo appdagent | passwd --stdin appdagent
                    echo host    all     all     10.20.0.62/32           md5>> /opt/pgsql/data/pg_hba.conf
                    service mirth-postgresql restart

                      "
echo "Appd Setup on DB server is done"
