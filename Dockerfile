# Base Image
FROM artifacts.intranet.mckinsey.com/gold-images/ruby:2.6-alpine

# Switching to root user
USER root

# Installing required libraries
RUN apk update && apk upgrade && \
apk add ruby ruby-json ruby-io-console ruby-bundler ruby-irb ruby-bigdecimal tzdata && \
apk add nodejs && \
apk add curl-dev ruby-dev build-base libffi-dev git && \
apk add build-base libxslt-dev libxml2-dev ruby-rdoc mysql-dev sqlite-dev && \
apk add mysql-client && \
apk add curl

ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.12/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=048b95b48b708983effb2e5c935a1ef8483d9e3e

RUN curl -fsSLO "$SUPERCRONIC_URL" \
 && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
 && chmod +x "$SUPERCRONIC" \
 && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
 && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

# Installing gems in gems's playground
RUN mkdir /gem_playground
WORKDIR /gem_playground

# For installing ThymeFieldAccommodator locally
#COPY LocalThymeFieldAccommodator ./LocalThymeFieldAccommodator

RUN gem install bundler
COPY Gemfile* ./
RUN bundle install

RUN mkdir -p /app
WORKDIR /app
COPY . .

# Adding a non root user
RUN addgroup -S carom
RUN adduser -u 1001 -S carom -G carom -h /home/carom
RUN chown -R carom /app
RUN chmod -R 777 /app

# Switching to non-root user 'carom'
USER carom

# Exposing 3000 port
EXPOSE 3000

ENTRYPOINT ["sh", "./config/docker/startup.sh"]