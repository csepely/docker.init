#!/bin/bash

# services order
services+=(pdns)

p_start[pdns]="pdns_server --no-config=yes --guardian=yes --daemon=yes --launch=gmysql --setgid=pdns --setuid=pdns --gmysql-host=db --gmysql-dbname=powerdns --gmysql-user=powerdns --gmysql-password=powerdns --gmysql-dnssec=yes"
p_pid[pdns]="pdns_control quit"
