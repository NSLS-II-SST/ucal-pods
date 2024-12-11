# ucal-pods

This repository contains the beamline-specific configuration and services for the ucal beamline.
It is designed to work with the nbs-pods framework.

## Prerequisites

- nbs-pods repository cloned in the same parent directory as this repository
- Docker and docker-compose installed

## Directory Structure

- `compose/`: Contains beamline-specific services and overrides
- `config/`: Contains beamline-specific configuration
- `scripts/`: Contains deployment and utility scripts

## Usage

To start all services:
```bash
./scripts/deploy.sh start
```

To start specific services:
```bash
./scripts/deploy.sh start service1 service2
```

To stop all services:
```bash
./scripts/deploy.sh stop
```

## Configuration

1. Edit `config/ipython/profile_default/startup/beamline.toml` to configure beamline settings
2. Edit `config/ipython/profile_default/startup/devices.toml` to configure devices
3. Add beamline-specific services in `compose/<service>/`
4. Customize core service settings in `compose/<service>/docker-compose.override.yml`
