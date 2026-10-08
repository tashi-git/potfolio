# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production.
#
# Build:
#   docker build -t potfolio .
#
# Run:
#   docker run -d -p 80:80 \
#     -e RAILS_MASTER_KEY=<value from config/master.key> \
#     --name potfolio \
#     potfolio

# Make sure this matches the Ruby version in .ruby-version
ARG RUBY_VERSION=4.0.6

# Use the official Ruby 4.0.6 slim image as our base image
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails application will live inside /rails
WORKDIR /rails


# ---------------------------------------------------------
# BASE IMAGE
# ---------------------------------------------------------

# Install packages required when the application is RUNNING.
#
# libpq5:
#   PostgreSQL client library.
#   Rails needs this to connect to PostgreSQL.
#
# libvips:
#   Used by image processing libraries such as Active Storage.
#
# libjemalloc2:
#   Memory allocator that can improve Ruby memory usage.
#
# curl:
#   General-purpose HTTP client.
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl \
      libjemalloc2 \
      libvips \
      libpq5 && \
    ln -s /usr/lib/$(uname -m)-linux-gnu/libjemalloc.so.2 /usr/local/lib/libjemalloc.so && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives


# ---------------------------------------------------------
# RAILS / BUNDLER ENVIRONMENT
# ---------------------------------------------------------

# Tell Rails to run in production mode
#
# BUNDLE_DEPLOYMENT=1:
#   Install gems in deployment mode.
#
# BUNDLE_PATH:
#   Location where Bundler installs gems.
#
# BUNDLE_WITHOUT:
#   Don't install development gems in production.
#
# LD_PRELOAD:
#   Use jemalloc for Ruby.
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so"


# ---------------------------------------------------------
# BUILD STAGE
# ---------------------------------------------------------

# This stage is temporary.
#
# It contains tools required to BUILD/install gems.
# These build tools won't be included in the final image.
FROM base AS build


# Install packages required to build Ruby gems.
#
# build-essential:
#   Compiler and build tools.
#
# git:
#   Needed if a gem comes from Git.
#
# libyaml-dev:
#   YAML development files.
#
# libpq-dev:
#   PostgreSQL development headers.
#   Required to build the Ruby "pg" gem.
#
# pkg-config:
#   Helps gems find system libraries.
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      libvips \
      libyaml-dev \
      libpq-dev \
      pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives


# ---------------------------------------------------------
# INSTALL RUBY GEMS
# ---------------------------------------------------------

# Copy any locally vendored gems, if they exist
COPY vendor/* ./vendor/

# Copy Gemfile and Gemfile.lock first.
#
# Docker can cache this layer.
# If your application code changes but Gemfile doesn't,
# Docker doesn't need to reinstall all gems.
COPY Gemfile Gemfile.lock ./


# Install all required Ruby gems
RUN bundle install && \
    rm -rf ~/.bundle/ \
      "${BUNDLE_PATH}"/ruby/*/cache \
      "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    \
    # Precompile Bootsnap for faster Rails startup
    # -j 1 avoids a known parallel compilation issue
    bundle exec bootsnap precompile -j 1 --gemfile


# ---------------------------------------------------------
# COPY APPLICATION
# ---------------------------------------------------------

# Copy the rest of your Rails application
COPY . .


# Precompile Bootsnap code for the Rails application.
#
# This makes Rails boot faster.
RUN bundle exec bootsnap precompile -j 1 app/ lib/


# ---------------------------------------------------------
# PRECOMPILE ASSETS
# ---------------------------------------------------------

# Compile Rails assets for production.
#
# SECRET_KEY_BASE_DUMMY allows assets to be compiled
# without providing the real Rails master/secret key.
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile


# ---------------------------------------------------------
# FINAL IMAGE
# ---------------------------------------------------------

# Start a fresh image from the smaller base image.
#
# Build tools such as build-essential and libpq-dev
# are NOT included here.
FROM base


# ---------------------------------------------------------
# SECURITY
# ---------------------------------------------------------

# Create a non-root "rails" group and user.
#
# Running Rails as a non-root user is safer than running
# the application as root.
RUN groupadd --system --gid 1000 rails && \
    useradd rails \
      --uid 1000 \
      --gid 1000 \
      --create-home \
      --shell /bin/bash


# Run the Rails application as the rails user
USER 1000:1000


# ---------------------------------------------------------
# COPY BUILT APPLICATION
# ---------------------------------------------------------

# Copy the installed Ruby gems from the build stage
COPY --chown=rails:rails \
    --from=build \
    "${BUNDLE_PATH}" \
    "${BUNDLE_PATH}"


# Copy the Rails application from the build stage
COPY --chown=rails:rails \
    --from=build \
    /rails \
    /rails


# ---------------------------------------------------------
# DATABASE PREPARATION
# ---------------------------------------------------------

# This script runs before Rails starts.
#
# Your bin/docker-entrypoint contains:
#
#   ./bin/rails db:prepare
#
# which prepares/updates the database before starting Rails.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]


# ---------------------------------------------------------
# SERVER
# ---------------------------------------------------------

# The Rails/Thruster server listens on port 80
# inside the container.
EXPOSE 80


# Start Thruster, which starts the Rails server.
CMD ["./bin/thrust", "./bin/rails", "server"]
