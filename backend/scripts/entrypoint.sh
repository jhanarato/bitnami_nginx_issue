#!/bin/bash

echo "Contents of backend service /app/certs"
ls -la /app/certs
exec python /app/app/backend.py

