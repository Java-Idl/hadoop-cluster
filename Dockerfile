ARG HADOOP_IMAGE_TAG=3.3.6
FROM apache/hadoop:${HADOOP_IMAGE_TAG}
USER root

# apache/hadoop:3.3.6 is based on CentOS 7 (EOL). Redirect yum repos to
# the frozen vault archive so installs still work.
RUN sed -i 's/mirror.centos.org/vault.centos.org/g' /etc/yum.repos.d/*.repo && \
    sed -i 's/^#.*baseurl=http/baseurl=http/g' /etc/yum.repos.d/*.repo && \
    sed -i 's/^mirrorlist=http/#mirrorlist=http/g' /etc/yum.repos.d/*.repo && \
    yum install -y python3 curl && \
    yum clean all

USER hadoop
