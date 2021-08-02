# Stage 1 - the build process
FROM node:16.5.0 as webapp

ARG CERTBOT_EMAIL=lego.chan@chunwo.com
ARG DOMAIN_LIST=itdog.life

LABEL version="1.0"

LABEL description="This is the base docker image for the react app "

LABEL maintainer = ["lego.chan@chunwo.com"]

WORKDIR /webapp
#ENV PATH /webapp/node_modules/.bin:$PATH

COPY package.json ./
COPY yarn.lock ./

RUN yarn && yarn cache clean

COPY . ./

RUN yarn build

FROM nginx:stable

#COPY --from=webapp /webapp/docker/nginx.conf /etc/nginx/nginx.conf
COPY --from=webapp /webapp/docker/nginx.prd.conf /etc/nginx/nginx.conf

RUN rm -rf /usr/share/nginx/html/*
COPY --from=webapp /webapp/build /usr/share/nginx/html

EXPOSE 8080
#EXPOSE 8443
CMD ["nginx", "-g", "daemon off;"]