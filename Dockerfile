FROM ruby:3.1.7-alpine

RUN apk add --update --no-cache bash curl

WORKDIR /app

COPY Gemfile Gemfile.lock /app/
RUN bundle install

COPY . /app/

EXPOSE 3000

ENV APP_ENV=production
CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0", "-p", "3000"]
