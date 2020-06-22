FROM node:alpine as builder
WORKDIR '/app'
COPY package*.json ./
RUN npm i ajv
RUN npm install
RUN npm install ip
COPY . .
CMD ["npm","start"]
