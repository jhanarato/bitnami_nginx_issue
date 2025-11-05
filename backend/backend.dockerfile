FROM python:3.11.3

ENV PYTHONUNBUFFERED 1

COPY sleep.py .
COPY entrypoint.sh .

RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
