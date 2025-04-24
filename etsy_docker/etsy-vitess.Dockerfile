# FROM golang:1.18.10-alpine3.17 AS go_builder

# switch to newer go version for playing around with Vitess v21
FROM golang:1.23.5-alpine3.21 AS go_builder

RUN apk add --update --no-cache bash gcc git libtool musl-dev ca-certificates

WORKDIR /vitess
ENV GOCACHE=/root/.cache/go-build \
    CGO_ENABLED=1
RUN --mount=type=cache,target=/go/pkg/mod/ \
    --mount=type=bind,source=go.sum,target=go.sum \
    --mount=type=bind,source=go.mod,target=go.mod \
    go mod download -x
COPY . ./
RUN --mount=type=cache,target=/go/pkg/mod/ \
    --mount=type=cache,target="/root/.cache/go-build" \
    bash ./build.env && \
    go build -o bin -trimpath -ldflags="-extldflags=-static -w -s $(tools/build_version_flags.sh)" -tags osusergo,netgo,sqlite_omit_load_extension ./...

# TODO: running tests might be a future goal for this as it looks to require Docker(DinD, yikes) and/or lot of external dependencies
# ENV PATH="/vitess/bin:$PATH"
# RUN --mount=type=cache,target=/go/pkg/mod/ \
#     --mount=type=cache,target="/root/.cache/go-build" \
#     bash ./build.env && \
#     go test -v ./go/...


WORKDIR /vitess/etsy_docker/cmd
ENV GOCACHE=/root/.cache/go-build \
    CGO_ENABLED=0
RUN --mount=type=cache,target=/go/pkg/mod/ \
    --mount=type=cache,target="/root/.cache/go-build" \
    mkdir -p /vitess/etsy_docker/bin && \
    go build -o /vitess/etsy_docker/bin -trimpath -ldflags="-extldflags=-static -w -s" ./...


FROM node:23-alpine3.21 AS node_builder
COPY ./web/vtadmin /vitess/web/vtadmin
WORKDIR /vitess/web/vtadmin

RUN npm install --omit=dev
RUN npx update-browserslist-db@latest
RUN npm run build


FROM alpine:3.17 AS debugger

# the mysql-client that's available is the MariaDB version, dunno how important that is right now?
# $ mysql --version
# mysql  Ver 15.1 Distrib 10.6.16-MariaDB, for Linux (x86_64) using readline 5.1
RUN apk add --update --no-cache bash curl jq mysql-client sqlite

# Create non-root vitess user
RUN addgroup --gid 3306 vitess && \
    adduser \
      --disabled-password \
      --gecos "Vitess" \
      --shell "/bin/bash" \
      --ingroup vitess \
      --uid 3306 \
    vitess

RUN mkdir -p --mode=1755 /opt/vitess/vtdataroot /opt/vitess/vtadmin-web

COPY --chown=3306:3306 etsy_docker/share/* /opt/vitess/vtdataroot/
COPY --chown=3306:3306 etsy_docker/mysql_schemas/dbindex.db /opt/vitess/vtdataroot/dbindex.db

COPY --from=go_builder /vitess/etsy_docker/bin/* /usr/local/bin/
# allow non-root users to bind to /dev/log for syslogging with chmod=4755
RUN chmod 4755 /usr/local/bin/syslog

COPY --from=go_builder \
      /vitess/bin/vtadmin \
      /vitess/bin/vtctl \
      /vitess/bin/vtctlclient \
      /vitess/bin/vtctld \
      /vitess/bin/vtctldclient \
      /vitess/bin/vtgate \
      /vitess/bin/vttablet \
  /usr/local/bin/

COPY --from=gcr.io/etcd-development/etcd:v3.5.17 /usr/local/bin/etcdctl /usr/local/bin

COPY --from=node_builder /vitess/web/vtadmin/build/ /opt/vitess/vtadmin-web/


USER vitess
COPY etsy_docker/bash/.bashrc /home/vitess/.bashrc
COPY --chmod=755 etsy_docker/bash/vtctl* /usr/local/bin/
ENTRYPOINT [ "/bin/bash" ]


FROM scratch

# the vitess app user needs to be able to write to /tmp
COPY --from=debugger --chown=3306:3306 /tmp /tmp
COPY --from=debugger --chown=3306:3306 /opt/vitess/ /opt/vitess/
COPY --from=debugger /etc/group /etc/group
COPY --from=debugger /etc/passwd /etc/passwd
COPY --from=debugger /usr/local/bin/* /usr/local/bin/

USER vitess
