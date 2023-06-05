FROM ubuntu:22.04


# DEB_DEPENDS from VPP's Makefile, added here to be cached
# This must be updated when the list of VPP dependencies change
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
	dnsmasq gettext-base \
    ca-certificates  curl \
    nfs-kernel-server \ 
	net-tools iputils-ping vim && \
	apt-get clean && \
	echo 'export TERM=xterm-256color' >> ~/.bashrc 

RUN mkdir /tftpboot 

# RUN \
# 	mkdir -pv /tftpboot/images && \
# 	mkdir -pv /tftpboot/kernels && \
# 	mkdir -pv /tftpboot/bios && \
# 	mkdir -pv /tftpboot/uefi && \
# 	chmod 777 -R /tftpboot

COPY dnsmasq.* /etc/
ENTRYPOINT ["/etc/dnsmasq.entrypoint"]
