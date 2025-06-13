# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.2.8
FROM ruby:$RUBY_VERSION-slim

WORKDIR /app

# Instala dependências do sistema para ambiente de desenvolvimento
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    apt-utils \
    gnupg2 \
    build-essential \
    libpq-dev \
    curl \
    git \
    libyaml-dev \
    libjemalloc2 \
    libvips \
    sqlite3 \
    nodejs \
    npm && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

# Variáveis de ambiente padrão
ENV RAILS_ENV=development \
    BUNDLE_PATH=/gems \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

# Copia e instala gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copia a aplicação
COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
