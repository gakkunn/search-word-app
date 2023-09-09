FROM ruby:2.5.7

RUN apt-get update -qq && apt-get install -y build-essential nodejs default-mysql-client default-libmysqlclient-dev vim

RUN mkdir /search-word-app

WORKDIR /search-word-app

COPY Gemfile /search-word-app/Gemfile
COPY Gemfile.lock /search-word-app/Gemfile.lock

RUN bundle install

COPY . /search-word-app

RUN RAILS_ENV=production bundle exec rails assets:precompile

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]