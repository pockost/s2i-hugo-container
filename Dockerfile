# hugo-centos7
FROM openshift/base-centos7

LABEL maintainer="Romain THERRAT <romain@pockost.com>"

ENV HUGO_VERSION 0.57.2

LABEL io.k8s.description="Platform for building HUGO website" \
      io.k8s.display-name="Hugo 0.57.2" \
      io.openshift.expose-services="1313:http" \
      io.openshift.tags="builder,0.57.2,hugo,html."

# Install hugo
RUN mkdir -p /usr/local/src \
    && cd /usr/local/src \

    && curl -L https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_linux-64bit.tar.gz | tar -xz \
    && mv hugo /usr/local/bin/hugo

# Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

# Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# Set the default port for applications built using this image
EXPOSE 1313

# Set the default CMD for the image
CMD ["/usr/libexec/s2i/usage"]
