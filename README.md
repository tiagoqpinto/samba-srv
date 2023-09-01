# samba-srv
Samba server using docker for creating network shares

---

- Supports up to 9 Shares with different users and permission
- User passwords transmitted through docker secrets
- works on arm


Nework share definition with environment variable `SHARE_0:path_folder:Username:rights`.
See example below.
Feel free to open issues for question and dicussions.

Docker compose example
```
version: "3.8"
services:
    samba-srv:
        image: ghcr.io/mladia/samba-srv:main
        container_name: samba-srv
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

