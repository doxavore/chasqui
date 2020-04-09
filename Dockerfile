FROM ruby:2.6.5
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client npm musl-dev
RUN mkdir /chasqui
WORKDIR /chasqui
RUN gem install bundler:2.1.4
COPY Gemfile /chasqui/Gemfile
COPY Gemfile.lock /chasqui/Gemfile.lock
RUN npm i -g yarn

# Configure bundle path for cache
ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

COPY . /chasqui

# Add a script to be executed every time the container starts.
COPY docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
