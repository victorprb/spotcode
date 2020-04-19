FROM ruby:2.6-alpine3.10
ARG APP_PATH=/app
ARG APP_USER=app
ARG APP_GROUP=app
ARG APP_USER_UID=1000
ARG APP_GROUP_GID=1000

RUN apk add --update bash git tzdata && \
    apk add --update --no-cache --virtual .build-deps \
      build-base \
      libxml2-dev libxslt-dev && \
    apk add --update "postgresql-client=~11" "postgresql-dev=~11" \
      nodejs yarn

# User handling
RUN addgroup -g $APP_GROUP_GID -S $APP_GROUP && \
    adduser -S -s /sbin/nologin -u $APP_USER_UID -G $APP_GROUP $APP_USER && \
    mkdir $APP_PATH && \
    chown $APP_USER:$APP_GROUP $APP_PATH

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

USER $APP_USER

WORKDIR $APP_PATH
COPY --chown=$APP_USER:$APP_GROUP Gemfile* $APP_PATH/

RUN bundle install

COPY --chown=$APP_USER:$APP_GROUP . $APP_PATH

ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
