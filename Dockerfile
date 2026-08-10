# syntax=docker/dockerfile:1
# check=error=true

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
FROM ruby:3.3.9

WORKDIR /app

# Install base packages
RUN apt-get update -qq && \
    apt-get install -y \
          build-essential \
          libpq-dev \
          curl \
          git && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0"]
