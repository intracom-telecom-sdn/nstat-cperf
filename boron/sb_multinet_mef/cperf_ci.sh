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

CONFIG_FILENAME=$1
NSTAT_WORKSPACE=/opt/nstat
RESULTS_DIR=$CONFIG_FILENAME"_results"
WAIT_UNTIL_RETRY=2
CONTAINER_IDS="nstat controller "$(echo mn-{01..02})

TEST_TYPE="mef_stability_test"

echo '-------------------------------------------------------------------------'
echo 'TEST TYPE      : '$TEST_TYPE
echo 'CONFIG_FILENAME: '$CONFIG_FILENAME
echo '-------------------------------------------------------------------------'

docker-compose up -d

for container_id in $CONTAINER_IDS
do
    docker exec -i $container_id /bin/bash -c "rm -rf $NSTAT_WORKSPACE; \
        cd /opt; \
        until git clone https://github.com/intracom-telecom-sdn/nstat.git -b develop_mef_tests; do \
            echo 'Fail git clone NSTAT. Sleep for $WAIT_UNTIL_RETRY and retry'; \
        done; \
        if [[ $container_id =~ mn ]]; then \
            until service openvswitch-switch start; do \
                echo 'Fail starting openvswitch service. Sleep for $WAIT_UNTIL_RETRY and retry'; \
                sleep $WAIT_UNTIL_RETRY; \
            done \
        fi"
done

docker cp $CONFIG_FILENAME.json nstat:$NSTAT_WORKSPACE

docker exec -i nstat /bin/bash -c "export PYTHONPATH=$NSTAT_WORKSPACE;source /opt/venv_nstat/bin/activate; \
python3.4 $NSTAT_WORKSPACE/stress_test/nstat_orchestrator.py \
     --test=$TEST_TYPE \
     --ctrl-base-dir=$NSTAT_WORKSPACE/controllers/odl_boron_pb/ \
     --sb-emulator-base-dir=$NSTAT_WORKSPACE/emulators/multinet/ \
     --json-config=$NSTAT_WORKSPACE/$CONFIG_FILENAME.json \
     --json-output=$NSTAT_WORKSPACE/${CONFIG_FILENAME}_results.json \
     --html-report=$NSTAT_WORKSPACE/report.html \
     --output-dir=$NSTAT_WORKSPACE/$RESULTS_DIR/"

docker cp nstat:$NSTAT_WORKSPACE/$RESULTS_DIR .
docker-compose down
