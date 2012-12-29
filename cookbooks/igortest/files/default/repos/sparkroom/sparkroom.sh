#!/bin/bash

# Runs the SparkRoom data aquisition and push into Odin

cd /home/pentaho/repos
/home/pentaho/pdi-ce-4.3.0/kitchen.sh /job="sparkroom/SparkRoom_Job" /level=Debug -param:"odin_Host"="http://localhost:9080" -param:"OUT_FILE_NAME"=/home/pentaho/tmp/sr.csv -rep=Kettle-Repo -dir=/
