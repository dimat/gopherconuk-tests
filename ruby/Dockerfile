FROM ruby:2.4.1

RUN mkdir /our-gem
ADD . /our-gem

WORKDIR /our-gem
RUN gem install bundler
RUN find . -name '*.gemspec' -execdir gem build {} \;
RUN find . -name '*.gem' -execdir gem install {} \;

RUN mkdir /gem
RUN mkdir /data

# Installing default gems
COPY Gemfile /gem
RUN cd /gem && bundle install

# Pick up gems when building a derived image
ONBUILD COPY Gemfile /gem
ONBUILD RUN cd /gem && bundle install --local

WORKDIR /data

ENTRYPOINT ["cucumber", "-c"]
