FROM golang:1.16.3-alpine3.13
CMD ["/bin/sh"]
ENV LANG=en_US.UTF-8
RUN apk --no-cache add syslog-ng openssl coreutils wget
RUN apk --no-cache upgrade
RUN wget -O- \
    https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.3/s6-overlay-amd64.tar.gz | \
    tar -zxvf - -C / 
ENTRYPOINT ["/init"]
COPY etc /etc/
RUN wget https://github.com/kelseyhightower/confd/releases/download/v0.16.0/confd-0.16.0-linux-amd64 && \
    mv confd-0.16.0-linux-amd64 /bin/confd && \
    chmod +x /bin/confd
RUN addgroup -g 2222 molly-brown
RUN adduser -h /home/molly-brown -S -D -u 2222 -G molly-brown molly-brown 
RUN addgroup molly-brown tty
RUN mkdir -p /var/gemini
RUN chown molly-brown:molly-brown /var/gemini
RUN mkdir -p /etc/molly-brown/keys/
RUN ln -sf /dev/stdout /home/molly-brown/access.log
RUN go get tildegit.org/solderpunk/molly-brown && \
    cp /go/bin/molly-brown /bin/molly-brown && \
    rm -rf /go
WORKDIR /var/gemini
VOLUME [/etc/molly-brown/keys /var/gemini/]
EXPOSE 1965/tcp