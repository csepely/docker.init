#!/bin/bash
#
# by Peter Csepely
# peter@csepely.hu
#
# init docker environment
. /docker.init/docker-func.in

# main
case "$1" in
  start)
    call_main_hook
  ;;
  *)
    echo ":: Executing >> $@ << ..."
    exec "$@"
esac
