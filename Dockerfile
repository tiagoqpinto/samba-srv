FROM ubuntu:latest

RUN apt update 
RUN apt install -y --no-install-recommends tzdata samba-common-bin samba

WORKDIR /app/
COPY smb.conf /app/smb.conf
COPY run.sh /app/run.sh


ENTRYPOINT ["bash", "./run.sh"]


HEALTHCHECK --interval=30s --timeout=10s \
  CMD smbclient -L \\localhost -U % -m SMB3
