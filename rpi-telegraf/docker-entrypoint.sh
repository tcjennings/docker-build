#!/bin/bash

if [[ ! -d /etc/telegraf/telegraf.conf.d ]]; then
mkdir -p /etc/telegraf/telegraf.conf.d
fi

#Create empty default config
telegraf --input-filter : --output-filter : config | grep -v "#" | uniq > /etc/telegraf/telegraf.conf

#Create a default cpu input and discard output if the conf.d directory is empty
if [[ ! "$(ls -A /etc/telegraf/telegraf.conf.d)" ]]; then
cat << EOF > /etc/telegraf/telegraf.conf.d/output-discard.conf
[[outputs.discard]]
EOF

cat << EOF > /etc/telegraf/telegraf.conf.d/input-cpu.conf
[[inputs.cpu]]
  percpu = true
  totalcpu = true
  collect_cpu_time = false
  report_active = false
EOF
fi

if [[ -n "$HOSTNAME_COMMAND" && -z "$TELEGRAF_AGENT_HOSTNAME" ]]; then
  export TELEGRAF_AGENT_HOSTNAME = $(eval $HOSTNAME_COMMAND)
fi

export TELEGRAF_AGENT_INTERVAL=${TELEGRAF_AGENT_INTERVAL-10s}
export TELEGRAF_AGENT_ROUND_INTERVAL=${TELEGRAF_AGENT_ROUND_INTERVAL-true}
export TELEGRAF_AGENT_METRIC_BATCH_SIZE=${TELEGRAF_AGENT_METRIC_BATCH_SIZE-1000}
export TELEGRAF_AGENT_METRIC_BUFFER_LIMIT=${TELEGRAF_AGENT_METRIC_BUFFER_LIMIT-10000}
export TELEGRAF_AGENT_COLLECTION_JITTER=${TELEGRAF_AGENT_COLLECTION_JITTER-0s}
export TELEGRAF_AGENT_FLUSH_INTERVAL=${TELEGRAF_AGENT_FLUSH_INTERVAL-10s}
export TELEGRAF_AGENT_FLUSH_JITTER=${TELEGRAF_AGENT_FLUSH_JITTER-0s}
export TELEGRAF_AGENT_PRECISION=${TELEGRAF_AGENT_PRECISION}
export TELEGRAF_AGENT_DEBUG=${TELEGRAF_AGENT_DEBUG-false}
export TELEGRAF_AGENT_QUIET=${TELEGRAF_AGENT_QUIET-false}
export TELEGRAF_AGENT_LOGFILE=${TELEGRAF_AGENT_LOGFILE}
export TELEGRAF_AGENT_HOSTNAME=${TELEGRAF_AGENT_HOSTNAME}
export TELEGRAF_AGENT_OMIT_HOSTNAME=${TELEGRAF_AGENT_OMIT_HOSTNAME-false}

for var in `env`
do
 if [[ $VAR =~ ^TELEGRAF_AGENT_ ]]; then
  tg_name=`echo "$VAR" | sed -r "s/TELEGRAF_AGENT_(.*)=.*\1/g" | tr '[:upper:]' '[:lower:]'`
  env_var=`echo "$VAR" | sed -r "s/TELEGRAF_AGENT_(.*)=.*\1/g"`
 egrep -w "[\s#]*hostname\s*=\s*" ./telegraf.conf.default
  if egrep -wq  "(^|\s|#)tg_name\s*=\s*" /etc/telegraf/telegraf.conf; then
   sed -r -i "s@(^|\s|^#)($tg_name)\s*=\s*(.*)@\2=${!env_var}@g" /etc/telegraf/telegraf.conf
  else
   echo "$tg_name = ${!env_var}" >> /etc/telegraf/telegraf.conf
  fi
 fi
done

set -e

if [ "${1:0:1}" = '-' ]; then
  set -- telegraf "$@"
fi

exec "$@"
