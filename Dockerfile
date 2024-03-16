FROM ruby:3.2.2-slim
RUN apt-get update \
    && apt-get install -qq -y curl --fix-missing --no-install-recommends \ 
    && apt-get update \
    && apt-get install -qq -y build-essential libpq5 libpq-dev cron git --fix-missing --no-install-recommends

RUN mkdir /course_center
RUN gem install bundler

WORKDIR /course_center
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .


EXPOSE 3000
CMD ["/bin/bash"]