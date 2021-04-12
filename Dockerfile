FROM python:3.7-alpine

RUN apk add --no-cache bash
RUN pip install Pygments

COPY repo /app/repo
COPY build.sh /app

WORKDIR /app
RUN ./build.sh --inner

WORKDIR /app/repo

EXPOSE 8080

CMD ["python", "-m", "http.server", "8080"]
