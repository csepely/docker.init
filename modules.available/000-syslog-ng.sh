p_start[syslog-ng]="/usr/sbin/syslog-ng --no-caps --pidfile /var/run/syslog-ng.pid"
p_pid[syslog-ng]="stop_syslog-ng"

# services order
services+=(syslog-ng)

# functions
function stop_syslog-ng {
  kill -SIGTERM $(cat /var/run/syslog-ng.pid)
}

function create_syslog_config {
cat << EOF > /etc/syslog-ng/syslog-ng.conf
@version: 3.5
@include "scl.conf"
@include "\`scl-root\`/system/tty10.conf"
options { chain_hostnames(off); flush_lines(0); use_dns(no); use_fqdn(no);
          owner("root"); group("adm"); perm(0640); stats_freq(0);
          bad_hostname("^gconfd$");
};
source s_src {
       unix-dgram("/dev/log");
       internal();
};
destination d_dst {
  file ("/var/log/syslog-ng.log");
};
log {
  source(s_src);
  destination(d_dst);
};
@include "/etc/syslog-ng/conf.d/*.conf"
EOF
}

before_service_start_hooks+=("create_syslog_config")
