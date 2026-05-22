FROM ruby:3.3.7

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  postgresql-client \
  nodejs && \
  rm -rf /var/lib/apt/lists/*

# App directory
WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy project
COPY . .

# Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
