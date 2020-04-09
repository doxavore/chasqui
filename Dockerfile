FROM ruby:2.6.5
RUN mkdir /chasqui
WORKDIR /chasqui

# Add a script to be executed every time the container starts.
COPY docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client npm musl-dev

RUN gem install bundler:2.1.4

RUN npm i -g yarn

# Configure bundle path for cache
ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

COPY . /chasqui

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
