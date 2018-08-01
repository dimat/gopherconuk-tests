FROM ruby:latest

RUN mkdir /gem
RUN mkdir /testresults

ADD example-proxy/Gemfile /gem

RUN mkdir -p /mock/lib
COPY lib /mock/lib
COPY glint-mock.gemspec /mock/
COPY Gemfile /mock/

WORKDIR /gem

RUN gem install bundler
RUN bundle install

RUN mkdir /data
WORKDIR /data
CMD ["bundle", "exec", "cucumber"]
