#!/bin/bash

if [ -f /root/scripts/stackrc ] ; then
	source /root/scripts/stackrc
else
	echo "ERROR!!! Failed to load /root/scripts/stackrc"
	exit 1
fi

function install_image {
  local name=$1
  local url=$2

  if [ ! -f /root/images/$name.qcow2 ]; then
    mkdir -p /root/images/
    curl -L -o /root/images/$name.qcow2 "$url"
  fi

  if ! glance index | grep "$name"; then
    glance --verbose add name=$name is_public=True protected=True disk_format=qcow2 container_format=bare < /root/images/$name.qcow2
  fi
}



if [ ! -f /etc/setup-done-glance ] ; then 

	echo " Nova Glance sync"
	glance-manage --config-dir /etc/glance db_sync

{% for name, url in pillar['openstack']['glance']['default_images'].iteritems() %}
	echo " Adding: {{ name }} : {{ url }}"
	install_image "{{ name }}" "{{ url }}"
{% endfor %}

	touch /etc/setup-done-glance
else
	echo " >>>>>>>>>>>>> Already setup Nova <<<<<<<<<<<"
	echo " >>>>>>>>> rm /etc/setup-done-glance <<<<<<<<"
	exit 1
fi
