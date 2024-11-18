FROM node:18.20.2-alpine AS build

COPY . /src
WORKDIR /src
RUN npm ci

FROM registry.access.redhat.com/ubi8:8.10-1132

EXPOSE 5488

RUN curl –sL https://rpm.nodesource.com/setup_18.x | bash -

ARG GOOGLE_CHROME_VERSION=130.0.6723.116

# version 131 of chrome will cause the jsreport error
#
# debug: pdf-utils detected 0 pdf operation(s) to process
# (because) error while executing pdf-utils operations
# (because) cannot read properties of undefined (reading 'object')
# TypeError: Cannot read properties of undefined (reading 'object')
#   at mergeStructTree (/src/node_modules/@jsreport/pdfjs/lib/mixins/utils/unionGlobalObjects.js:125:63)
# ARG GOOGLE_CHROME_VERSION=131.0.6778.69
ARG CHROME_URL=https://dl.google.com/linux/chrome/rpm/stable/x86_64/google-chrome-stable-${GOOGLE_CHROME_VERSION}-1.x86_64.rpm

RUN dnf config-manager --add-repo https://vault.centos.org/centos/8/BaseOS/x86_64/os && \
  dnf config-manager --add-repo https://vault.centos.org/centos/8/AppStream/x86_64/os && \
  dnf install -y --nogpgcheck  \
  nodejs-18.20.2 \
  vulkan \
  xdg-utils \
  liberation-fonts \
  ${CHROME_URL}

COPY --from=build --chown=jsreport:jsreport /src/ /src/

ENV NODE_ENV=production

CMD ["/bin/sh", "-c", "node /src/server.js --configFile=/src/config.json"]
