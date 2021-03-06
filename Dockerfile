#######################BUILD IAMGE################
FROM rust:1.42.0 as build
ENV REFRESHED_AT 2020-08-30
RUN mkdir /app && cd /app && git clone https://github.com/smoothsea/check-in.git && cd check-in
WORKDIR /app/check-in
RUN cargo build --release

#######################RUNTIME IMAGE##############
FROM debian:buster-slim
RUN apt-get update && apt-get install -y \
    --no-install-recommends \
    openssl \
    ca-certificates
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone 
COPY --from=build app/check-in/target/release/checkin .
COPY --from=build app/check-in/config /etc/checkin
WORKDIR /
CMD ["/checkin"]

