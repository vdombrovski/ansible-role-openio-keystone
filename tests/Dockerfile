FROM ubuntu:16.04
MAINTAINER Romain Acciari <romain.acciari@openio.>

# Install Ansible
RUN \
    (cd /lib/systemd/system/sysinit.target.wants/ || exit; for i in *; do [ "$i" = systemd-tmpfiles-setup.service ] || rm -f "$i"; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*; \
    apt-get update; \
    apt-get install -y software-properties-common git wget; \
    apt-add-repository -y ppa:ansible/ansible; \
    add-apt-repository cloud-archive:pike; \
    apt-get update; \
    apt-get install -y ansible python-netaddr; \
    echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts; \
    echo "[defaults]\nretry_files_enabled = False" > /etc/ansible/ansible.cfg;
COPY ./gridinitcmd.py /usr/lib/python2.7/dist-packages/ansible/modules/system/gridinitcmd.py
RUN echo "lookup_plugins = /etc/ansible/plugins/lookups\n\
filter_plugins = /etc/ansible/plugins/filters\n\
action_plugins = /etc/ansible/plugins/actions\n\
library = /etc/ansible/plugins/library\n" >>/etc/ansible/ansible.cfg; \
    mkdir /etc/ansible/plugins; \
    wget https://github.com/openstack/openstack-ansible-plugins/archive/stable/pike.tar.gz -O - |tar xzf - -C /etc/ansible/plugins --strip 1;
#RUN wget https://raw.githubusercontent.com/racciari/ansible-gridinit/master/modules/system/gridinitcmd.py -O /usr/lib/python2.7/dist-packages/ansible/modules/system/gridinitcmd.py;

VOLUME ["/sys/fs/cgroup"]
CMD ["/sbin/init"]

