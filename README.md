# members-database

Ruby on Rails app for a database of artists and their artworks

## HOW TO

### Add a new user to the database

Connect to the Rails console using Heroku:

`heroku run rails c -a <app-name>`

Create a user:

Role can be admin. artist, or curator.

```ruby
User.create!(
  email: "jane@gmail.com",
  first_name: "Jane",
  last_name: "Smith",
  role: "artist",
  password: "a password",
  password_confirmation: "a password"
)