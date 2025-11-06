#!/bin/bash

echo "Backend username"
whoami

echo "Backend user id"
id -u

echo "Backend group id"
id -g

echo "Contents of backend service /app/certs"
ls -la /app/certs
exec python /app/app/backend.py

