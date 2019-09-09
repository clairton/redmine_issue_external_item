FROM redmine:4-alpine

ENV REDMINE_DB_HOST localhost
ENV REDMINE_DB_PASSWORD ''
ENV REDMINE_DB_USERNAME redmine
ENV REDMINE_DB_DATABASE sqlite/redmine.db
ENV REDMINE_DB_PORT ''
ENV REDMINE_DB_ITEM_ADAPTER sqlite3

ENV REDMINE_DB_ITEM_HOST localhost
ENV REDMINE_DB_ITEM_PASSWORD ''
ENV REDMINE_DB_ITEM_USERNAME redmine
ENV REDMINE_DB_ITEM_DATABASE sqlite/redmine.db
ENV REDMINE_DB_ITEM_PORT ''
ENV REDMINE_DB_ITEM_ADAPTER sqlite3

COPY database.yml /usr/src/redmine/config/database.yml

# this could removed when found image for commit https://github.com/docker-library/redmine/commit/89e332359934f039709ac47d8317e88e2b410575
RUN sed "s/require 'yaml'/require 'yaml'\n\t\t\trequire 'erb'/g" -i /docker-entrypoint.sh
RUN sed "s/load_file('.\/config\/database.yml')/load(ERB.new(File.read('.\/config\/database.yml')).result)/g" -i /docker-entrypoint.sh


EXPOSE 4000
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "4000"]