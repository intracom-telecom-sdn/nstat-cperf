# NSTAT: Automated stress tests for OPFNV/Cperf project

## Overview
The repository contains scripts for automatically running all SDN controller
performance [stress tests](https://github.com/intracom-telecom-sdn/nstat/wiki)
with the aid of the [NSTAT](https://github.com/intracom-telecom-sdn/nstat)
suite. At the moment json input files are provided for two different versions
of the OpenDaylight controller, Beryllium and Boron SR1. These files are stored
under

```bash
./beryllium
./boron
```
directories. For running the tests on a host machine, the tools and the steps
below should be installed and followed.

## Essential tools

- [docker](https://docs.docker.com/engine/installation/) (v.1.12.1 or later)
- [docker-compose](https://docs.docker.com/compose/install/) (v.1.8.0 or later)

## Installation

For running the tests, clone the [NSTAT:OPFNV/Cperf](https://github.com/intracom-telecom-sdn/nstat-cperf#nstat-automated-stress-tests-for-opfnvcperf-project)
on the host machine.

-  Step 1
```bash
git clone --branch v1.0 https://github.com/intracom-telecom-sdn/nstat-cperf.git nstat-cperf
```

-  Step 2
Give read/write/execute permissions for any user in /opt
```bash
chmod 777 -R /opt
```
-  Step 3

Give non-root access to docker daemon

* Add the docker group if it doesn't already exist
sudo groupadd docker

* Add the connected user "${USER}" to the docker group. Change the user name to
match your preferred user

```bash
sudo gpasswd -a ${USER} docker
```

* Restart the Docker daemon:
```bash
sudo service docker restart
```
-  Step 4

```yaml
    ulimits:
      nofile:
        soft: 1000000
        hard: 1000000
```

## Run the tests

- [Flow scalability test with idle Multinet switches](https://github.com/intracom-telecom-sdn/nstat/wiki/Flow-scalability-test-with-idle-Multinet-switches)
  - ./$NSTAT_CPERF_DIR/boron/nb_multinet/cperf_ci.sh boron_nb_active_scalability_multinet.json

- [Switch scalability test with active MT-Cbench switches](https://github.com/intracom-telecom-sdn/nstat/wiki/Switch-scalability-test-with-active-MT-Cbench-switches)
  - ./$NSTAT_CPERF_DIR/boron/sb_mtcbench/cperf_ci.sh boron_DS_sb_active_scalability_mtcbench.json
  - ./$NSTAT_CPERF_DIR/boron/sb_mtcbench/cperf_ci.sh boron_RPC_sb_active_scalability_mtcbench.json
- [Controller stability test with active MT-Cbench switches](https://github.com/intracom-telecom-sdn/nstat/wiki/Controller-stability-test-with-active-MT-Cbench-switches)
  - ./$NSTAT_CPERF_DIR/boron/sb_mtcbench/cperf_ci.sh boron_DS_sb_active_stability_mtcbench.json
  - ./$NSTAT_CPERF_DIR/boron/sb_mtcbench/cperf_ci.sh boron_RPC_sb_active_stability_mtcbench.json
- [Switch scalability test with idle MT-Cbench switches](https://github.com/intracom-telecom-sdn/nstat/wiki/Switch-scalability-test-with-idle-MT-Cbench-switches)
  - ./$NSTAT_CPERF_DIR/boron/sb_mtcbench/cperf_ci.sh boron_DS_sb_idle_scalability_mtcbench.json
  - ./$NSTAT_CPERF_DIR/boron/sb_mtcbench/cperf_ci.sh boron_RPC_sb_idle_scalability_mtcbench.json
- [Switch scalability test with active Multinet switches](https://github.com/intracom-telecom-sdn/nstat/wiki/Switch-scalability-test-with-active-Multinet-switches)
  - ./$NSTAT_CPERF_DIR/boron/sb_multinet/cperf_ci.sh boron_sb_active_scalability_multinet.json
- [Switch scalability test with idle Multinet switches](https://github.com/intracom-telecom-sdn/nstat/wiki/Switch-scalability-test-with-idle-Multinet-switches)
  - ./$NSTAT_CPERF_DIR/boron/sb_multinet/cperf_ci.sh boron_sb_idle_scalability_multinet.json
- [Controller stability test with idle Multinet switches](https://github.com/intracom-telecom-sdn/nstat/wiki/Controller-stability-test-with-idle-Multinet-switches)
  - ./$NSTAT_CPERF_DIR/boron/sb_multinet/cperf_ci.sh boron_sb_idle_stability_multinet.json

### Test Execution sequence

Every cperf_ci.sh script and given the aforementioned ```*.json``` file will deploy
the proper number of containers as defined in ```docker-compose.yml``` file.

For example the ```docker-compose.yml``` located under ```/boron/sb_mtcbehch```
defines three containers ```nstat, controller, mtcbench``` which will be created
out of the (1) ```intracom/nstat:proxy``` (2) ```intracom/nstat:controller_pb_proxy```
(3)  ```intracom/mtcbench:proxy``` images. These images are prebuilt, and located
under [hub.dockerhub/intracom](https://hub.docker.com/u/intracom/).

Once the docker containers are up and running, the test input ```*.json``` is copied
on to the NSTAT container

```bash
docker cp $CONFIG_FILENAME.json nstat:$NSTAT_WORKSPACE
```
and a ```docker-exec``` command follows

```bash
docker exec -i nstat /bin/bash -c
...
```
which will execute the proper test. Once the test is over, the results folder
is copied back to the ```HOST``` and all containers are killed. The user can
then navigate to the ```RESULTS_DIR``` directory to check all test results.
Parameters ```NSTAT_WORKSPACE, RESULTS_DIR``` are defined within the
```cperf_ci.sh``` script.


![Test execution](images/cperf.png)

## Contact and Support

For issues regarding NSTAT, please use the [issue tracking](https://github.com/intracom-telecom-sdn/nstat/issues) section.
For any other questions and feedback, contact us at [nstat-support@intracom-telecom.com](mailto:nstat-support@intracom-telecom.com).

