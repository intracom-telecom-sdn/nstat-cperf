#!/bin/bash

# Copyright (c) 2015 Intracom S.A. Telecom Solutions. All rights reserved.
#
# This program and the accompanying materials are made available under the
# terms of the Eclipse Public License v1.0 which accompanies this distribution,
# and is available at http://www.eclipse.org/legal/epl-v10.html

# Usage: ./cperf_ci TEST_FILE.json
# Prerequisites:
# - docker
# - docker-compose
TEST_FILE=$1
CONFIG_FILENAME=`echo "$TEST_FILE" | cut -d'.' -f1`
NSTAT_WORKSPACE=/opt/nstat
RESULTS_DIR=$CONFIG_FILENAME"_results"

TMP=${CONFIG_FILENAME#*_}
#TEST_TYPE=${TMP%}
TEST_TYPE=${TMP%_*}

echo '-------------------------------------------------------------------------'
echo 'TEST TYPE      : '$TEST_TYPE
echo 'CONFIG_FILENAME: '$CONFIG_FILENAME
echo '-------------------------------------------------------------------------'

docker-compose up -d

for container_id in nstat controller mn-01 mn-02 mn-03 mn-04 mn-05 mn-06 mn-07 mn-08 mn-09 mn-10 mn-11 mn-12 mn-13 mn-14 mn-15 mn-16
do
    docker exec -i $container_id /bin/bash -c "rm -rf $NSTAT_WORKSPACE && \
        cd /opt && \
        git clone https://github.com/intracom-telecom-sdn/nstat.git -b master && \
    if [ "$container_id" == "mn-01" ] || [ "$container_id" == "mn-02" ] || [ "$container_id" == "mn-03" ] || [ "$container_id" == "mn-04" ] || [ "$container_id" == "mn-05" ] || [ "$container_id" == "mn-06" ] || [ "$container_id" == "mn-07" ] || [ "$container_id" == "mn-08" ] || [ "$container_id" == "mn-09" ] || [ "$container_id" == "mn-10" ] || [ "$container_id" == "mn-11" ] || [ "$container_id" == "mn-12" ] || [ "$container_id" == "mn-13" ] || [ "$container_id" == "mn-14" ] || [ "$container_id" == "mn-15" ] || [ "$container_id" == "mn-16" ] ; then
        service openvswitch-switch start
    fi"
done

docker cp $CONFIG_FILENAME.json nstat:$NSTAT_WORKSPACE

docker exec -i nstat /bin/bash -c "export PYTHONPATH=$NSTAT_WORKSPACE;source /opt/venv_nstat/bin/activate; \
python3.4 $NSTAT_WORKSPACE/stress_test/nstat_orchestrator.py \
     --test=$TEST_TYPE \
     --ctrl-base-dir=$NSTAT_WORKSPACE/controllers/odl_boron_pb/ \
     --sb-generator-base-dir=$NSTAT_WORKSPACE/emulators/multinet/ \
     --json-config=$NSTAT_WORKSPACE/$CONFIG_FILENAME.json \
     --json-output=$NSTAT_WORKSPACE/${CONFIG_FILENAME}_results.json \
     --html-report=$NSTAT_WORKSPACE/report.html \
     --output-dir=$NSTAT_WORKSPACE/$RESULTS_DIR/"

docker cp nstat:$NSTAT_WORKSPACE/$RESULTS_DIR .
docker-compose down
