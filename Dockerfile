#######################
#  base
#######################
ARG RUBY_VERSION=2.6.5
FROM ruby:${RUBY_VERSION}-slim-buster AS base

ARG PG_MAJOR_VERSION=11
ARG NODE_MAJOR_VERSION=12
ARG BUNDLER_VERSION=2.1.4
ARG YARN_VERSION=1.22.4

ENV LANG=C.UFT-8 \
    LC_ALL=C.UTF-8 \
    LANGUAGE=C.UTF-8 \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
EXPOSE 3000

# Install base requirements needed for other tooling (NodeJS, etc).
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
      apt-transport-https \
      build-essential \
      curl \
      git \
      gnupg2 \
      lsb-release \
      libvips \
  && apt-get clean \
  && apt-get autoremove \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

# Add PostgreSQL to sources list
RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" ${PG_MAJOR_VERSION} > /etc/apt/sources.list.d/pgdg.list

# Add NodeJS to sources list
RUN curl -sL https://deb.nodesource.com/setup_${NODE_MAJOR_VERSION}.x | bash -

# Add Yarn to the sources list
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb http://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

# Install selected version of tools.
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
      libpq-dev \
      postgresql-client-${PG_MAJOR_VERSION} \
      nodejs \
      yarn=${YARN_VERSION}-1 \
  && apt-get clean \
  && apt-get autoremove \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

RUN gem install bundler:${BUNDLER_VERSION}

RUN mkdir -p /app
WORKDIR /app

#######################
#  development
#######################
FROM base AS development

RUN echo "alias be='bundle exec'" >> /root/.bashrc

#######################
#  production
#######################
FROM base AS production

ENV RAILS_ENV=production \
    NODE_ENV=production

RUN mkdir -p tmp/downloads tmp/pids tmp/sockets

COPY package.json yarn.lock /app/
RUN yarn install --production \
  && yarn cache clean

COPY Gemfile Gemfile.lock /app/
RUN bundle config no-cache true \
  && bundle config deployment true \
  && bundle install

COPY . /app/

RUN bundle exec rails assets:precompile
