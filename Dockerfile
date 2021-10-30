FROM ruby:2.7.2 AS base
MAINTAINER souvik.khan@ymail.com

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y cmake nodejs && apt-get install yarn

RUN gem install bundler

      WORKDIR /usr/src/app

FROM base AS dev
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install

FROM base AS build
ADD . .
RUN bundle config set without 'development test' && \
  bundle config set deployment 'true' && \
  bundle install
  RUN RAILS_ENV=production bin/rails assets:precompile
  RUN rm -rf node_modules

FROM ruby:2.7.2 AS prod
WORKDIR /usr/src/app
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /usr/src/app .

CMD ["/bin/bash", "./bin/drun.sh"]

