FROM ruby:2.3-alpine
LABEL maintainer="fabiosantos.pe@gmail.com"


# Install apt based dependencies required to run Rails
ENV DEV_PACKAGES="build-base ruby-dev zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev postgresql postgresql-dev" \
    RAILS_PACKAGES="nodejs"

# RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN apk --update --upgrade add $RAILS_PACKAGES $DEV_PACKAGES

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
RUN mkdir -p /app
WORKDIR /app

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5

# Copy the main application.
COPY . ./

# Expose port 3000 to the Docker host, so we can access it
# from the outside.
EXPOSE 3000

# The main command to run when the container starts. Also
# tell the Rails dev server to bind to all interfaces by
# default.
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
