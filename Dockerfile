# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.4
FROM ruby:${RUBY_VERSION}-slim AS base

WORKDIR /app

ENV BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

COPY . .

FROM base

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /app /app

RUN groupadd --system --gid 1000 lokka && \
    useradd lokka --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R lokka:lokka /app

USER lokka:lokka

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
