FROM ruby:2.5.1-alpine as bundler

RUN apk add --update alpine-sdk sqlite-dev

COPY Gemfile* /usr/src/app/

WORKDIR /usr/src/app

RUN bundle install --jobs 5

# ------------------------------------------------------------------------------

FROM ruby:2.5.1-alpine

RUN apk add --update bash sqlite sqlite-dev bind-tools tzdata curl nodejs

# the default ruby image includes a version of rake that is too new for us to use
RUN gem uninstall -i /usr/local/lib/ruby/gems/2.5.0 rake

COPY --from=bundler $BUNDLE_PATH $BUNDLE_PATH

RUN mkdir /usr/src/app

WORKDIR /usr/src/app

COPY . /usr/src/app

RUN bundle exec rake db:create db:schema:load db:seed

CMD '/bin/bash'
