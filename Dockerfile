FROM golang:1-buster AS builder

ARG VERSION

RUN cd /tmp/ \
 && git clone -n https://github.com/kiwiirc/webircgateway.git \
 && cd webircgateway \
 && git checkout ${VERSION} \
 && make

# ---

FROM debian:buster-slim AS webircgateway

COPY --from=builder /tmp/webircgateway/webircgateway /usr/local/bin/webircgateway
COPY --from=builder /tmp/webircgateway/config.conf.example /etc/webircgateway/config.conf

EXPOSE 80

CMD [ "/usr/local/bin/webircgateway", "--config=/etc/webircgateway/config.conf" ]