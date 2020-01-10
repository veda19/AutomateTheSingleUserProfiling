#!/bin/sh
echo
echo
echo "Waiting for a couple of minutes so that the agent can transfer the Details to the AppD Server"
echo
echo
echo
sleep 1m
#echo "The response time for /Login.action is 18ms"
TRANSACTION=$1
xmlResponse="$(curl --user cdrscrumteam@nextgenhealthcare-nonprod:h0tc0ff33 "https://nextgenhealthcare-nonprod.saas.appdynamics.com/controller/rest/applications/MR/metric-data?metric-path=Business%20Transaction%20Performance%7CBusiness%20Transactions%7CMR%7C%2Fmirthresults%2F$TRANSACTION.action%7CAverage%20Response%20Time%20%28ms%29&time-range-type=BEFORE_NOW&duration-in-mins=20")"
val=$(grep -oPm1 "(?<=<value>)[^<]+" <<< "$xmlResponse")
echo
echo
if [ -z "$val" ]
then
#echo "AppD isn't showing any data for the Transaction. Please try again after sometime"
echo "AppD isn't showing any data for the Transaction. Please try again after sometime" > /c/Users/vprakash/Desktop/output/output.txt
else
#echo "The Average Response Time for the Transaction $TRANSACTION is $val ms"
echo "The Average Response Time for the Transaction $TRANSACTION is $val ms" > /c/Users/vprakash/Desktop/output/output.txt
fi


# var="$(curl --user cdrscrumteam@nextgenhealthcare-nonprod:h0tc0ff33 "https://nextgenhealthcare-nonprod.saas.appdynamics.com/controller/rest/applications/helprodmrclone/request-snapshots?time-range-type=BEFORE_NOW&duration-in-mins=20&business-transaction-ids={130068}")"
#val=$(grep -oPm1 "(?<=<timeTakenInMilliSecs>)[^<]+" <<< "$var")
#echo $val
#sed -2 '/<timeTakenInMilliSecs>/,/<\/timeTakenInMilliSecs>/p' $var
#grep timeTakenInMilliSecs /c/Users/vprakash/Desktop/output/temp.xml
#echo $var
#echo "$var" >  /c/Users/vprakash/Desktop/output/temp.xml
#echo
#if [ -z "$val" ]
#then
#echo "No Data Found"
#echo "No Data Found" >> /c/Users/vprakash/Desktop/output/output.txt
#else
#echo "The Execution Times of all the calls are given below "
#echo
#grep 'timeTakenInMilliSecs' /c/Users/vprakash/Desktop/output/temp.xml | awk -F">" '{print $2}' | awk -F"<" '{print $1}'

# echo >> /c/Users/vprakash/Desktop/output/output.txt
# echo "The Execution Times of all the calls are given below " >> /c/Users/vprakash/Desktop/output/output.txt
# echo
# grep 'timeTakenInMilliSecs' /c/Users/vprakash/Desktop/output/temp.xml | awk -F">" '{print $2}' | awk -F"<" '{print $1}' >> /c/Users/vprakash/Desktop/output/output.txt
# fi
# cat /c/Users/vprakash/Desktop/output/output.txt