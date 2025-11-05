#!/bin/bash

echo "Listing contents of /app/certs"
ls -la /app/certs
exec python /app/app/backend.py

