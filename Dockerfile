FROM ruby:3.3-slim

# Install system dependencies needed by Jekyll
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /site

# Install gems first (better Docker cache behavior)
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install

# Copy the rest of the site
COPY . .

# Jekyll serves on 4000 by default
EXPOSE 4000

# Default command
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--livereload"]
