FROM centos:7
MAINTAINER Alex Drahon <adrahon@gmail.com>
RUN yum install -y https://repos.fedorapeople.org/repos/openstack/openstack-kilo/rdo-release-kilo-1.noarch.rpm &&\
    yum install -y \
      openstack-keystone \
      openstack-utils \
      openstack-selinux &&\
    yum clean all
COPY ./start /
EXPOSE 5000
CMD ["/start"]
