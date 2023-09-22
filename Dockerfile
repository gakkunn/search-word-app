FROM ruby:2.5.7

RUN apt-get update -qq && apt-get install -y build-essential nodejs default-mysql-client default-libmysqlclient-dev vim

RUN mkdir /search-word-app

WORKDIR /search-word-app

COPY Gemfile /search-word-app/Gemfile
COPY Gemfile.lock /search-word-app/Gemfile.lock

RUN bundle install

COPY . /search-word-app

# デプロイ(push)するときだけ以下の3行を実行、開発環境でのビルド時はコメントアウト
ARG RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY ${RAILS_MASTER_KEY}

# Yarnの公式リポジトリを追加
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# 更新して最新のyarnをインストール
RUN apt-get update && apt-get install -y yarn

# バージョンを確認
RUN yarn --version

RUN RAILS_ENV=production bundle exec rails assets:precompile

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
