# FSSS (Fedora System Setup Scripts)
Pronounced as "F-Triple-S"

## Overview
This repository contains a collection of scripts to automate Fedora system setup and configuration.

## Usage Instructions

### Preparation
1. Generate your custom `settings.conf` by running `./generate_settings.sh`
    - You can also make a copy of `settings.conf.sample` and edit it manually
2. Inspect the scripts to ensure they meet your specific requirements
3. Run `setup_fedora.sh` to begin the deployment process

## Directory Structure

### `cleanup/`
Contains cleanup scripts that are executed at the end of the deployment process. These scripts handle final system configuration, removing temporary files, and performing last-minute system adjustments.

### `core/`
Scripts in this directory define fundamental system parameters and core configuration values. These scripts set baseline system settings that are critical to the overall system setup.

### `customs/`
Contains specialized, system-dependent scripts that are **NOT** run by default. These scripts should be:
- Carefully reviewed before execution
- Considered as examples
- Manually invoked only after thorough inspection
- Understood to be highly specific to particular system configurations

### `manual/`
Scripts to install software that are heavily depedendent on what you want / what you have. Eg.: Controlling AIO CPU Coolers

### `packages/`
Scripts dedicated to installing and deploying specific software packages. Each script typically handles the installation, configuration, and initial setup of a particular application or software suite.

### `utils/`
Utility scripts designed to:
- Improve deployment process maintainability
- Enhance script readability
- Provide helper functions
- Streamline configuration and setup tasks

## Caution
Always review scripts before execution and ensure they align with your system requirements and security policies.

## License
This project is licensed under the MIT License. See [MIT License](https://opensource.org/licenses/MIT) for details.
