FROM alpine:3.10 AS build
WORKDIR /xmrig
RUN     echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
		apk --no-cache upgrade && \
        apk --no-cache add \
        git \
        cmake \
        libuv-dev \
        build-base \
        openssl-dev \
        hwloc-dev \       
        && \
      git clone https://github.com/xmrig/xmrig.git && \
      cd xmrig && \
      sed -i 's/kMinimumDonateLevel = 1/kMinimumDonateLevel = 0/' src/donate.h && \
      sed -i 's/kDefaultDonateLevel = 5/kDefaultDonateLevel = 0/' src/donate.h && \
      cmake . -DCMAKE_BUILD_TYPE=Release && make


FROM    alpine:3.10
RUN     adduser -S -D -H -h /xmrig miner && \
        echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
        apk --no-cache upgrade && \
        apk --no-cache add \
        libuv-dev \
        openssl-dev \
        hwloc-dev
COPY --from=build /xmrig/xmrig /xmrig/
USER miner
WORKDIR /xmrig
ENTRYPOINT ["./xmrig"]
CMD ["--url=qrl.fungibly.xyz:9999", "--user=Q0103008fdde861cae98046eb9087d74e88b7a162640c5a4442434bc4269f2d117bf2303b881aec", "--pass=x@azure", "-k", "--tls", "-t 4"]˚
