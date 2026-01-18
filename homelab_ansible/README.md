## Usage

### On the target System(s)
- Make sure `sudo` is available on target systems
  `apt install sudo`

- Create the user on the target system which will be used
  ```adduser ansible_user```
  

- Add your public key to the user's `authorized_keys`
  ```mkdir -p ~/.ssh```
  ```touch authorized_keys```
  ```chmod 600 authorized_keys```
  

### On this System

- Copy your `host_files` secrets to the root directory
    - it should be ./host_files/<inventory_name>/<directory>
    - eg: ./host_files/discovery/docker-stack/nginx-reverse-proxy

- Copy your `host_vars` to the root directory

- Copy your `group_vars` to the root directory

- Run a playbook
  ```ansible-playbook deploy_systems.yml -K```

- Set up your user's password
  ```sudo passwd docker-user```


## On the Docker Compose Stack(s)

### First Time Setup

If running for the first time, start each stack:
```docker compose up -d```


### Recovering Backups

If recovering backups, first restore your volumes, then start each stack
```docker compose up -d```


