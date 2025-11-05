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