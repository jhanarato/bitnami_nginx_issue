# Debugging nginx issue in SuttaCentral `elastic-bilara` setup

This will set things up and clean up afterwards.

```commandline
mkdir logs/nginx --parents --mode 777 
docker compose up --build -d 
docker compose down -v
```
