To Get Started:

1. Clone repo.
2. Install npm modules `npm install`.
3. Import seed data to mongo `mongoimport --db test --collection items --type
   json --file seed.json --jsonArray`.
4. Install coffeescript globally `npm install -g coffee-script`.
5. Run coffeescript compilation continuously `coffee --watch --compile --output
   public/js client`
6. Install supervisor globally `npm install supervisor`
4. Run server via supervisor `supervisor server/app.coffee`.
