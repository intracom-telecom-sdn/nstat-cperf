# NSTAT: Automated stress tests for OPFNV/Cperf project

## Overview
The repository contains scripts for automatically running all SDN controller
performance [stress tests](https://github.com/intracom-telecom-sdn/nstat/wiki)
with the aid of the [NSTAT](https://github.com/intracom-telecom-sdn/nstat)
suite. At the moment json input files are provided for two different versions
of the OpenDaylight controller, Beryllium and Boron SR1.

## Essential tools

- docker (v.1.12.1 or later)
- docker-compose (v.1.8.0 or later)

## Installation

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

### Folder structure

### Run a single test

### Run all tests in chain


## Contact and Support

For issues regarding NSTAT, please use the [issue tracking](https://github.com/intracom-telecom-sdn/nstat/issues) section.
For any other questions and feedback, contact us at [nstat-support@intracom-telecom.com](mailto:nstat-support@intracom-telecom.com).

