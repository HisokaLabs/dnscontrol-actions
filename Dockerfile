FROM alpine:3.24.3

LABEL org.opencontainers.image.title="DNSControl Action"
LABEL org.opencontainers.image.description="Deploy your DNS configuration using DNSControl."
LABEL org.opencontainers.image.source="https://github.com/HisokaLabs/dnscontrol-actions"
LABEL org.opencontainers.image.licenses="ISC"
LABEL maintainer="Hisoka Labs <contact@hisoka.net>"

LABEL "com.github.actions.name"="DNSControl Action"
LABEL "com.github.actions.description"="Deploy your DNS configuration using DNSControl."
LABEL "com.github.actions.icon"="cloud"
LABEL "com.github.actions.color"="blue"

ENV DNSCONTROL_VERSION="5.7.2"
ENV DNSCONTROL_CHECKSUM="e4022a8b7def34b5876f6bdc0db0479e0dd7e19708f82c98428cce537c79b82d"
ENV USER=dnscontrol-user

RUN apk -U --no-cache upgrade && \
    apk add --no-cache bash ca-certificates curl libc6-compat tar

RUN addgroup -S dnscontrol-user && adduser -S dnscontrol-user -G dnscontrol-user --disabled-password

RUN curl -sL "https://github.com/StackExchange/dnscontrol/releases/download/v${DNSCONTROL_VERSION}/dnscontrol_${DNSCONTROL_VERSION}_linux_amd64.tar.gz" \
    -o dnscontrol && \
    echo "$DNSCONTROL_CHECKSUM  dnscontrol" | sha256sum -c - && \
    tar xvf dnscontrol
 
RUN chown dnscontrol-user:dnscontrol-user dnscontrol
 
RUN chmod +x dnscontrol && \
    chmod 755 dnscontrol && \
    mv dnscontrol /usr/local/bin/dnscontrol

RUN ["dnscontrol", "version"]

COPY README.md entrypoint.sh bin/filter-preview-output.sh /

RUN chmod +x /entrypoint.sh && \
    chmod +x /filter-preview-output.sh

ENTRYPOINT ["/entrypoint.sh"]