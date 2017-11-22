p_start[lighttpd]="/usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf"
p_pid[lighttpd]="stop_lighttpd"

# services order
services+=(lighttpd)

function stop_lighttpd {
  kill -SIGTERM $(cat /var/run/lighttpd.pid)
}

function create_lighttpd_config {
  install -d -o www-data -g www-data -m 0750 "/var/run/lighttpd"
  lighttpd-enable-mod accesslog fastcgi-php
}

before_service_start_hooks+=("create_lighttpd_config")
