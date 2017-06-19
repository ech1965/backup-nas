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
       python-dev  \
       build-essential libssl-dev libffi-dev \
       libxml2-dev libxslt1-dev zlib1g-dev \
       python-pip \
       wget zip unzip vim git

#
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install duplicacy 2.0.0
# pour le moment on s'en passe puisqu'on travaille avec mon fork
#RUN cd /root && \
#    wget --no-check-certificate -O duplicacy https://github.com/gilbertchen/duplicacy-cli/releases/download/v2.0.0/duplicacy_linux_x64_2.0.0 && \
#    chmod a+x duplicacy && \
#    cp duplicacy /usr/bin

# Activate SSH
RUN rm -f /etc/service/sshd/down

# Install startup scripts
RUN mkdir -p /etc/my_init.d
ADD cont-init.d/10-adduser                /etc/my_init.d/10-adduser
ADD cont-init.d/20-configure-ssh          /etc/my_init.d/20-configure-ssh
RUN chmod +x /etc/my_init.d/10-adduser    /etc/my_init.d/20-configure-ssh

EXPOSE 22

################### 
# Volumes expected to be mapped
# /config : config files (should be ro)
# expected to contain
# /config/ssh ( host and user key )
# /config/authorized_keys
# /config/crontab
# /restore : where to restore files
# /datahome    : source directory for local backup (ro)
# /dataperso   : Source directory for local backup (ro)
# /pref-dirs   : Directory for  pref-dir option from Duplicacy
# /reports     : Directory for storing report files
# /restore     : Where restore commands should restore files
VOLUME /config /datahome /dataperso /pref-dirs /restore /reports



