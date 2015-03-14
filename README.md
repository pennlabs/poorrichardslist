To Get Started:

1. Clone repo.
2. Install npm modules `npm install`.
3. Import items seed data to mongo `mongoimport --db test --collection items --type
   json --file items-seed.json --jsonArray`.
4. Import tags seed data to mongo `mongoimport --db test --collection tags --type
   json --file tags-seed.json --jsonArray`.
5. Install coffeescript globally `npm install -g coffee-script`.
6. Install grunt globally `sudo npm install -g grunt-cli`.
7. After confirming Ruby installation `ruby -v`, install Sass `gem install sass`.
8. Run grunt to continuously compile html and coffeescript files `grunt watch`.
9. Install supervisor globally `npm install supervisor`
10. Run server via supervisor `supervisor server/app.coffee`.
