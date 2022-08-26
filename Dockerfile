# Base Image
FROM mckinsey-elm-dope-docker.jfrog.io/gold-images/ruby:3.0

# Switching to root user
USER root

# Installing required libraries
RUN apt-get update -qq
RUN apt-get install -y build-essential curl git nodejs libmariadb-dev figlet vim

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

ARG JFROG_USERNAME
ARG JFROG_PASSWORD

RUN gem install --source https://$JFROG_USERNAME:$JFROG_PASSWORD@mckinsey.jfrog.io/artifactory/api/gems/rubygems bundler
COPY Gemfile* ./
RUN bundle config set --global mckinsey.jfrog.io $JFROG_USERNAME:$JFROG_PASSWORD
RUN bundle update --bundler
RUN bundle install
RUN bundle update

RUN mkdir -p /app
WORKDIR /app
COPY . .

# Adding a non root user
RUN groupadd --system carom
RUN useradd -u 1001 --system carom -g carom -d /home/carom -m -s /bin/bash
RUN chown -R carom /app
RUN chmod -R 777 /app

# Adding figlet :)
RUN echo "figlet -cl 'Carom'" >> /home/carom/.bashrc

# Switching to non-root user 'carom'
USER carom

# Exposing 3000 port
EXPOSE 3000

ENTRYPOINT ["sh", "./config/docker/startup.sh"]