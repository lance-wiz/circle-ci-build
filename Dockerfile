FROM node:14

# Exposed port with no auth layer
EXPOSE 8080

# Outdated or vulnerable package versions
RUN npm install -g express@4.17.1 lodash@4.17.20

COPY . /app
WORKDIR /app
CMD ["node", "server.js"]
