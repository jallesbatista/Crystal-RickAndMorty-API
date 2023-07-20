# Imagem base
FROM crystallang/crystal:1.8.2-alpine AS builder

WORKDIR /app

RUN apk --no-cache add libpq make

COPY shard.yml shard.lock  ./

RUN shards install 

COPY . .

RUN crystal build --release src/code_challenge.cr -o code_challenge

FROM crystallang/crystal:1.8.2-alpine

RUN apk --no-cache add libpq postgresql-client

COPY --from=builder /app/code_challenge /usr/local/bin/code_challenge

WORKDIR /app

COPY . .

