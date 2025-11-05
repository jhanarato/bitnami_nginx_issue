#!/bin/bash

echo "Backend username"
whoami

echo "Backend UID"
id -u

echo "Contents of backend service /app/certs"
ls -la /app/certs
exec python /app/app/backend.py

