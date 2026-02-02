FROM debian:trixie-slim

WORKDIR /opt

RUN apt-get update && \
    apt-get install -y wget gpg coreutils make git lsb-release

RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && \
    apt-get install -y nomad

COPY ./nomad-conf.hcl /etc/nomad.d/master-conf.hcl

EXPOSE 4646
EXPOSE 4647

CMD [ "nomad", "agent", "-server", "-config=/etc/nomad.d/master-conf.hcl", "-bind", "0.0.0.0", "-network-interface='{{ GetDefaultInterfaces | attr \"name\" }}'" ]
