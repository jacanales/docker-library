FROM busybox

ENV   VERSION=1.22.1.0
ADD   https://github.com/just-containers/s6-overlay/releases/download/v$VERSION/s6-overlay-amd64.tar.gz /tmp/

RUN   gunzip -c /tmp/s6-overlay-amd64.tar.gz | tar -xf - -C /

ENTRYPOINT ["/init"]

CMD ["/bin/ash"]