# samba
Samba server using docker for creating network shares

---
forked from:
https://github.com/Mladia/samba-srv 

- Supports up to 9 Shares with different users and permission
- User passwords transmitted through docker secrets
- works on arm (raspberry pi)


Nework share definition with environment variable `SHARE_0:path_folder:Username:rights`.
See example below.
Feel free to open issues for question and dicussions.

Docker compose example
```
version: "3.8"
services:
    samba:
        container_name: samba
        image: tiagoqpinto/samba
        restart: always
        ports:
          - 445:445
        secrets:
          - Alice
          - Bob
        volumes:
            - /storage/media:/share/media
            - /storage/data:/share/data
        environment:
          SHARE_1: "Media:/share/media:Alice:rw"
          SHARE_2: "Data:/share/data:Alice:rw"
          SHARE_3: "Media-r:/share/media:Bob:r"

secrets:
    Alice:
      file: /app/samba-srv/Alice
    Bob:
      file: /app/samba-srv/Bob
```

Image derived from linuxserver base image.

For the developer, build and push commands:

```
docker build -t tiagoqpinto/samba:latest -t tiagoqpinto/samba:v1.0.0 .
docker image push --all-tags tiagoqpinto/samba
```
