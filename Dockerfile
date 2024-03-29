FROM ubuntu:focal AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git ansible build-essential && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base AS d9r
ARG TAGS
RUN addgroup --gid 1000 d9r 
RUN adduser --gecos d9r --uid 1000 --gid 1000 --disabled-password d9r
USER d9r
WORKDIR /home/d9r

FROM d9r
COPY . .
CMD ["sh", "-c", "ansible-playbook $TAGS local.yml"]
