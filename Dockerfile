FROM ruby:2.5-alpine

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile.docker /app/Gemfile
COPY Gemfile.lock /app/

RUN gem install bundler
RUN apk add --no-cache bash nodejs mysql-client mysql-dev sqlite-dev less
RUN apk add --no-cache alpine-sdk \
      --virtual .build_deps libxml2-dev libxslt-dev zlib zlib-dev \
      && cd /app \
      && bundle install -j4 --without postgresql:sqlite \
      && apk del alpine-sdk .build_deps \
      && rm -rf /tmp/* /var/cache/apk/*

COPY . /app
COPY Gemfile.docker /app/Gemfile

CMD ['bundle', 'exec', 'rackup']
