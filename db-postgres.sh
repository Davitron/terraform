#!/usr/bin/env bash
# File: Ansible

set -x
# Install postgresql to setup server configuration process
function postgresqlInstall {
  sudo apt-get update -y

  sudo apt-get install postgresql postgresql-contrib -y
  sudo sed -i "s/#listen_address.*/listen_addresses '*'/" /etc/postgresql/9.5/main/postgresql.conf
  sudo -u postgres psql postgres --command  '\password abcd1234'
  sudo /etc/init.d/postgresql restart
  sudo -u postgres createdb events_manager
}

postgresqlInstall
