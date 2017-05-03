#!/bin/sh

NAME="v4l2loopback"
PIDFILE="/var/run/${NAME}.pid"
LAUNCHER="/usr/bin/v4l2loopback-launcher"
DAEMON="/usr/bin/v4l2loopback"

case "$1" in
  start)
    echo -n "Starting $NAME: "
    if start-stop-daemon --start --quiet --make-pidfile --pidfile "/var/run/${NAME}.pid" --background --exec "${LAUNCHER}"
    then
        echo "done."
    else
        echo "FAILED!"
        exit 1
    fi
    ;;
  stop)
    echo -n "Stopping $NAME:"
    if start-stop-daemon -K -s TERM --quiet --oknodo --pidfile "/var/run/${NAME}.pid" &&
       start-stop-daemon --stop -s TERM --quiet --oknodo --exec "${DAEMON}"
    then
        echo "done."
    else
        echo "FAILED!"
        exit 1
    fi
    ;;
  status)
    echo -n "${NAME} "
    if start-stop-daemon -q -K -t -p "${PIDFILE}" 2>/dev/null
    then
        PID="$(cat "${PIDFILE}")"
        echo "(${PID}) is running"
    else
        echo "is not running"
        exit 1
    fi
    ;;
  restart)
    "$0" stop
    sleep 1
    "$0" start
    ;;

  *)
    echo "Usage: $0 {start|stop|restart|status}"
    exit 1
esac

