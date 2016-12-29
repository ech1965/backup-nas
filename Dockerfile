FROM phusion/baseimage:0.9.19

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
RUN apt-get update -y && \ 
    apt-get dist-upgrade -y --no-install-recommends && \
    apt-get install -y --no-install-recommends \
       rsync \
       rdiff-backup \
       python-cherrypy3 python python-pysqlite2 libsqlite3-dev python-jinja2 python-setuptools python-babel \
       wget
#
# Activate SSH
RUN rm -f /etc/service/sshd/down

# Install startup scripts
RUN mkdir -p /etc/my_init.d
ADD cont-init.d/10-adduser       /etc/my_init.d/10-adduser
ADD cont-init.d/20-configure-ssh /etc/my_init.d/20-configure-ssh
RUN chmod +x /etc/my_init.d/10-adduser /etc/my_init.d/20-configure-ssh

# Install rdiff-viewer
RUN cd /root && \
    wget --no-check-certificate -O rdiffweb.tar.gz https://github.com/ikus060/rdiffweb/archive/master.tar.gz && \
    tar zxf rdiffweb.tar.gz && \
    cd rdiffweb-* && \
    python setup.py install

#ADD 00-install-rdiffweb /00-install-rdiffweb
#RUN chmod +x /00-install-rdiffweb && /00-install-rdiffweb

# Install service script for rdiffweb
RUN mkdir -p /etc/service/rdiffweb
ADD service/rdiffweb/run /etc/service/rdiffweb/run
RUN chmod +x /etc/service/rdiffweb/run

EXPOSE 22 8080

################### 
# Volumes expected to be mapped
# /config : config files (should be ro)
# expected to contain
# /config/ssh ( host and user key )
# /config/authorized_keys
# /config/crontab
# /backup : destination backup dir
# expect a directory named $PUSER
# /restore : where to restore files
# /data    : source directory for local backup (ro)
VOLUME /repositories /config /sourcedata /restore /etc/rdiffweb /jobs /reports

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

