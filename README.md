To Get Started:

1. Clone repo.
2. Install npm modules `npm install`.
3. Import seed data to mongo `mongoimport --db test --collection items --type
   json --file seed.json --jsonArray`.
4. Install coffeescript globally `npm install -g coffee-script`.
5. Install grunt globally `sudo npm install -g grunt-cli`.
6. Run grunt to continuously compile html and coffeescript files `grunt watch`.
7. Install supervisor globally `npm install supervisor`
8. Run server via supervisor `supervisor server/app.coffee`.
