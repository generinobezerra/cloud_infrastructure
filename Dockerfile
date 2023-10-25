FROM node:14
LABEL authors="Generino Bezerra"

WORKDIR /app

COPY . /app

RUN npm install -g n \
&& n 12.9.0 \
&& npm install -g yarn \
&& yarn install \
&& yarn add typeorm-transactional \
&& yarn add typeorm reflect-metadata --save


EXPOSE 3000

# Initializing the application
CMD ["yarn", "typeorm", "migration:run"]
