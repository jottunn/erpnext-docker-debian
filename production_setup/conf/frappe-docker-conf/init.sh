#!/bin/bash

# turn on debug mode > https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euxo pipefail

# copy traefik config
cp /home/$systemUser/production_config/acme.toml /home/frappe/traefik-config/acme.toml

# env has been set from dockerfile
benchWD=/home/$systemUser/$benchFolderName

# change working directory
cd $benchWD

# change folder owner
sudo chown -R $systemUser:$systemUser sites/*
sudo chown -R $systemUser:$systemUser logs/*

# remove old site
cd sites
rm -rf $siteName
cd ..

# config bench
bench set-mariadb-host mariadb

# create new site
bench new-site $benchNewSiteName
bench use $benchNewSiteName

# create install erpnext
bench install-app erpnext

# fixed JS error
bench update --build
