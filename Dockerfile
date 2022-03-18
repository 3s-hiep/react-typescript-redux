FROM node:14 as builder

WORKDIR /app

COPY ./package*.json /app/

RUN npm ci

COPY tsconfig*.json /app/
COPY src /app/src
COPY public /app/public
RUN npm run build

FROM nginx:1.21.1 as runner

COPY --from=builder /app/build /usr/share/nginx/html

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/nginx-angular.conf /etc/nginx/templates/angular.conf.template
COPY ./nginx/security-header.conf /etc/nginx/security-headers.conf
CMD ["nginx", "-g", "daemon off;"]