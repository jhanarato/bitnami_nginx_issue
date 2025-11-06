FROM python:3.11.3

ENV PYTHONUNBUFFERED 1

WORKDIR /app/

COPY . .

RUN chmod +x /app/scripts/entrypoint.sh
RUN chmod g+w /app/certs

CMD ["/app/scripts/entrypoint.sh"]
