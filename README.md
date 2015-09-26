# Poor Richard's List

A student marketplace that makes buying, selling, and searching for goods delightful.

## Contributing

To Get Started:

1. Clone repo.
2. Install npm modules `npm install`.
3. Install coffeescript globally `npm install -g coffee-script`.
4. Add `.env` file in the root directory with appropriate environment variables.
5. [Install MongoDB](http://docs.mongodb.org/manual/installation/) for your platform.
6. Generate seed item/tag data `coffee scripts/seed.coffee`.
[Note: this has lead to an obscure error at the mongoskin level that is hard to replicate. To remedy try: (1) make sure you have created a default data directory `mkdir -p /data/db` (2) start mongo: `mongod` or `</data/db>mongod` (3) `sudo chown -R `id -u` /data/db` or (4) `npm install mongoose` ]
5. Install grunt globally `sudo npm install -g grunt-cli`.
6. After confirming Ruby installation `ruby -v`, install Sass `gem install sass`.
7. Run grunt to continuously compile html and coffeescript files `grunt watch`.
8. Install supervisor globally `npm install supervisor -g`
9. Run server via supervisor `supervisor server/app.coffee`.

## System Administration

To deploy on the server, you must run the `deploy.sh` script.
