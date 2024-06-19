FROM node:20.14.0-alpine

WORKDIR /app

COPY ./package.json .
COPY ./package-lock.json .

ENV NODE_ENV production
ENV REDIS_HOST localhost
ENV REDIS_PORT 6379
ENV REDIS_USE_TLS false
ENV REDIS_PASSWORD ''
ENV ADMIN_USER ''
ENV ADMIN_PASSWORD ''
ENV REDIS_DB 0
ENV PROXY_PATH ''

RUN npm i -g pm2

RUN npm install --save

COPY . .

ARG PORT=3000
ENV PORT $PORT
EXPOSE $PORT

CMD ["node", "build/index.js"]
