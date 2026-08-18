ARG HADOOP_IMAGE_TAG=3.3.6
FROM apache/hadoop:${HADOOP_IMAGE_TAG}
USER root

# apache/hadoop:3.3.6 is based on CentOS 7 (EOL June 2024). Upstream mirrors
# and mirrorlists are dead, so replace the repo files outright with pinned
# vault/archive baseurls instead of patching the originals in place —
# sed-patching the shipped files is fragile (it silently no-ops if their
# format ever differs) and was the actual cause of prior install failures.
RUN rm -f /etc/yum.repos.d/*.repo && \
    cat > /etc/yum.repos.d/CentOS-Archive.repo <<'EOF'
[base]
name=CentOS-7 - Base
baseurl=https://vault.centos.org/7.9.2009/os/x86_64/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[updates]
name=CentOS-7 - Updates
baseurl=https://vault.centos.org/7.9.2009/updates/x86_64/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[extras]
name=CentOS-7 - Extras
baseurl=https://vault.centos.org/7.9.2009/extras/x86_64/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
EOF

# EPEL archive, kept for any package not in base/updates/extras.
# CentOS 7.7+ already ships python3 in base, so this isn't required for
# python3 itself, but it's harmless to have available.
RUN cat > /etc/yum.repos.d/epel-archive.repo <<'EOF'
[epel]
name=Extra Packages for Enterprise Linux 7 - Archive
baseurl=https://archives.fedoraproject.org/pub/archive/epel/7/x86_64/
enabled=1
gpgcheck=1
gpgkey=https://archives.fedoraproject.org/pub/archive/epel/RPM-GPG-KEY-EPEL-7
EOF

# Import the CentOS 7 signing key (bundled in the base image) so gpgcheck=1
# above actually has something to verify against, instead of disabling
# signature verification outright.
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && \
    yum clean all && \
    yum makecache && \
    yum install -y python3 curl && \
    yum clean all && \
    rm -rf /var/cache/yum

# Build-time sanity check — fail fast here instead of at container runtime.
RUN python3 --version && curl --version

USER hadoop