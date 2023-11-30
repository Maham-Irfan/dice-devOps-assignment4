FROM node:18-alpine
RUN mkdir -p /app
WORKDIR /app
COPY . .
RUN npm i
RUN npm run build
EXPOSE 3000
ENTRYPOINT ["npm","run","dev"]