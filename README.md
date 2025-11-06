# Debugging nginx issue in SuttaCentral `elastic-bilara` setup

The logs directory must be created like so or nginx won't run.

```commandline
mkdir logs/nginx --parents --mode 777 
```

Now, if we clean up and run like this the keys are generated and nginx runs:

```commandline
docker compose down -v
docker compose up nginx
```

And we can now get the backend running:

```commandline
docker compose up --build
```

However, if we clean up and try to build everything:

```commandline
docker compose down -v
docker compose up --build
```

Nginx can't start: (I deleted the .+ output of the script for brevity here)
```
nginx  | req: Can't open "/certs/localhost.key" for writing, Permission denied
nginx  | req: Can't open "/certs/key.pem" for writing, Permission denied
nginx  | nginx 09:32:24.25 INFO  ==> ** Starting NGINX **
nginx  | 2025/11/05 09:32:24 [warn] 1#1: the "user" directive makes sense only if the master process runs with super-user privileges, ignored in /opt/bitnami/nginx/conf/nginx.conf:2
nginx  | nginx: [warn] the "user" directive makes sense only if the master process runs with super-user privileges, ignored in /opt/bitnami/nginx/conf/nginx.conf:2
nginx  | 2025/11/05 09:32:24 [emerg] 1#1: cannot load certificate "/certs/localhost.crt": BIO_new_file() failed (SSL: error:80000002:system library::No such file or directory:calling fopen(/certs/localhost.crt, r) error:10000080:BIO routines::no such file)
nginx  | nginx: [emerg] cannot load certificate "/certs/localhost.crt": BIO_new_file() failed (SSL: error:80000002:system library::No such file or directory:calling fopen(/certs/localhost.crt, r) error:10000080:BIO routines::no such file)
dependency failed to start: container nginx is unhealthy
```

When running `docker compose up nginx` we get this:

```
nginx  | Nginx UID
nginx  | 1001
nginx  | Contents of nginx service /certs
nginx  | total 24
nginx  | drwxrwxr-x 2 root root 4096 Nov  5 09:54 .
nginx  | drwxr-xr-x 1 root root 4096 Nov  5 09:54 ..
nginx  | -rw-r--r-- 1 1001 root 1115 Nov  5 09:54 cert.pem
nginx  | -rw------- 1 1001 root 1704 Nov  5 09:54 key.pem
nginx  | -rw-r--r-- 1 1001 root 1115 Nov  5 09:54 localhost.crt
nginx  | -rw------- 1 1001 root 1708 Nov  5 09:54 localhost.key
```

If we just build:

```
nginx  | Nginx UID
nginx  | 1001
nginx  | Contents of nginx service /certs
nginx  | total 8
nginx  | drwxr-xr-x 2 root root 4096 Nov  5 05:05 .
nginx  | drwxr-xr-x 1 root root 4096 Nov  5 09:56 ..
```

Note the differences:

```
# Good
nginx  | drwxrwxr-x 2 root root 4096 Nov  5 09:54 .
# Bad
nginx  | drwxr-xr-x 2 root root 4096 Nov  5 05:05 .
```

So the `/certs` directory is writable by the user and group owner in the first instance and owner only in the second.

In both cases the user owner and group owner are root.

The nginx service runs as uid 1001. The backend service runs as uid 0, root.

Both run as group root

# `nginx` service makes `/certs` writeable

If we now remove the shell script from the `nginx` service altogether, along with the configuration file, like this:

```yaml
  nginx:
    image: bitnamilegacy/nginx
    container_name: nginx
    volumes:
      - ./logs/nginx/:/var/logs/nginx
      - ./frontend:/var/www/html
      - certs:/certs
      - ./scripts/generate_nginx_certs.sh:/scripts/generate_nginx_certs.sh
    ports:
      - 9080:80
    healthcheck:
      test: ["CMD-SHELL", "test -f /certs/key.pem && test -f /certs/cert.pem"]
      interval: 1s
      timeout: 5s
      retries: 60
    restart: unless-stopped
```

The `/certs` directory looks like this:

```commandline
jr@JR25:~/Code/elastic-bilara$ docker exec -it nginx bash
I have no name!@550068fdcd48:/app$ ls -la /certs
total 16
drwxrwxr-x 2 root root 4096 Nov  5 11:15 .
drwxr-xr-x 1 root root 4096 Nov  5 11:15 ..
-rw-r--r-- 1 1001 root 1809 Nov  5 11:15 tls.crt
-rw------- 1 1001 root 3272 Nov  5 11:15 tls.key
```