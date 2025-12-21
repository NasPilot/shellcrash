############################
# Stage 1: builder
############################
FROM alpine:latest AS builder

# Arguments
ARG TARGETPLATFORM
ARG TZ=Asia/Shanghai
ARG S6_OVERLAY_V=v3.2.1.0

# Install dependencies
RUN apk add --no-cache curl tzdata

# Set timezone
RUN ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${TZ}" > /etc/timezone

WORKDIR /build

# Install ShellCrash
RUN set -eux; \
    mkdir -p /tmp/SC_tmp; \
    tar -zxf ShellCrash.tar.gz -C /tmp/SC_tmp; \
    export systype=container; \
    export CRASHDIR=/etc/ShellCrash; \
    /bin/sh /tmp/SC_tmp/init.sh


# Download s6-overlay
RUN set -eux; \
	case "$TARGETPLATFORM" in \
      linux/amd64) S=x86_64;; \
      linux/arm64) S=aarch64;; \
      linux/arm/v7) S=arm;; \
      linux/386) S=i486;; \
      *) echo "unsupported $TARGETPLATFORM" && exit 1 ;; \
    esac; \
    curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_V}/s6-overlay-${S}.tar.xz" -o /tmp/s6_arch.tar.xz; \
    curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_V}/s6-overlay-noarch.tar.xz" -o /tmp/s6_noarch.tar.xz && ls -l /tmp


############################
# Stage 2: runtime
############################
FROM alpine:latest

# Arguments
ARG TZ=Asia/Shanghai

# Labels
LABEL maintainer="𝑬𝓷𝒅𝒆 ℵ" version="1.9.3"

# Install runtime dependencies
RUN apk add --no-cache \
    wget \
    ca-certificates \
    tzdata \
    nftables \
    iproute2 \
    dcron

# Set timezone
RUN ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${TZ}" > /etc/timezone

# Copy files from builder
COPY --from=builder /etc/ShellCrash /etc/ShellCrash
COPY --from=builder /etc/profile /etc/profile
COPY --from=builder /usr/bin/crash /usr/bin/crash

# Install s6-overlay
COPY --from=builder /tmp/s6_arch.tar.xz /tmp/s6_arch.tar.xz
COPY --from=builder /tmp/s6_noarch.tar.xz /tmp/s6_noarch.tar.xz
RUN tar -xJf /tmp/s6_noarch.tar.xz -C / && rm -rf /tmp/s6_noarch.tar.xz
RUN tar -xJf /tmp/s6_arch.tar.xz -C / && rm -rf /tmp/s6_arch.tar.xz
COPY docker/s6-rc.d /etc/s6-overlay/s6-rc.d
ENV S6_CMD_WAIT_FOR_SERVICES=1

# Copy and set custom entrypoint
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
