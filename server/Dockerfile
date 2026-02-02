FROM debian:trixie-slim

RUN apt-get update && \
    apt-get install wget gpg coreutils make git

RUN wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && \
    apt-get install nomad

COPY ./nomad-conf.hcl /etc/nomad.d/master-conf.hcl

EXPOSE 4646

CMD [ "nomad", "-config=/etc/nomad.d/master-conf.hcl" ]
