#!/bin/bash
source .env
apiExport=$(curl -s $apiURL$apiChecksum)

attendees=$(echo $apiExport | grep -o '<attendee>' | wc -l)
attendeesWithVideo=$(echo $apiExport | grep -o '<hasVideo>true</hasVideo>' | wc -l)

recordsOnQueue=$(ls -la  /var/bigbluebutton/recording/status/sanity/ | grep done | wc -l)
recordsToday=$(ls -la  /var/bigbluebutton/recording/status/archived/ | grep done | wc -l)

recordsPublishedDays=$(cat /etc/cron.daily/bigbluebutton | grep -m 1 'published_days=' | cut -d'=' -f 2)
recordsDelete=$(find /var/bigbluebutton/recording/raw/*/events.xml  -mtime +$recordsPublishedDays | cut -d"/" -f6 | wc -l)

cpuUsage=$(echo $[100-$(vmstat 1 2|tail -1|awk '{print $15}')])

echo $attendees attendees in BBB-Meetings
echo $attendeesWithVideo attendees in BBB-Meetings with activated webcams
echo Still rendering $recordsOnQueue meetings
echo Recorded $recordsToday meetings today
echo $cpuUsage CPU Usage in percent
echo $recordsDelete are published, older than $recordsPublishedDays days and will be deleted today
