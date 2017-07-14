# Susana

Light weight Ruby web application framework based on Rack

### Features
- Super fast and light weight
- Live code reloading
- Asset packer and helpers
- Erb and JSON support
- Rails style controllers
- Secure sessions, flash and cookies
- Regular expressions included
- Action filters
- Parameter validations
- Background queue included
- Language translations
- Sinatra style route matchers
- Mailgun email client
- Amazon and Rackspace uploads
- Optional models
- MongoDB adapter and client
- Easy to use and customizable


### Installation
Susana can be cloned directly from here or installed using rubygems.

Read the [susana gem README](https://github.com/fugroup/susana/blob/master/gem/README.md) to install Susana.

### Philosophy
Susana is written from scratch on top of Rack, with inspiration from Rails and Sinatra. It's only a few hundred lines of code, but is more complete than Sinatra in that we include a curated collection of gems to provide you with everything you need. Just install, load the app and start coding your views, completely turnkey.

Every app is unique with different requirements. If you want to customize it, you can. We include all the code inside of your application and you can customize every part of it, no code is hidden inside gems. The source code is well documented and easy to understand.

### Configuration
Configuration files are found in the `config` directory. More info is found at the top of each file. The `config/boot.rb` file loads all of the gems, app files and the files in the `config/init` directory. The `config.ru` file sets up the middleware and runs the app.

### Locales and sitemap
The language translations are found in `config/locales`. Just add your file and it will be automatically loaded. Emails, routes and sitemap supports translations out of the box. For the routes, just add a `/lang/` in front of the path. The sitemap entries can be added in `lib/susana/sitemap.rb`.

### Database
MongoDB is ready to use out of the box as long as you have mongod running on localhost. The `config/database.yml` lets you specify the connection. The [Easymongo client](https://github.com/fugroup/easymongo) is already integrated and connects automatically. Using a database has never been this easy.

### Email
Mail is sent via [Mailgun](https://mailgun.com) using our client. Set up your `mailgun_api_url` in `settings.yml` and you are ready to send emails. Your email templates are found in `app/views/mail` and also includes layout and support for translations. Mails are sent in the background in a separate thread.

### Code reloading
Once you start your application, all assets, ruby and yaml files are reloaded automatically so you see your changes immediately without having to restart the application. We've added autoload on most of the libraries included, so startup is fast as well.

### Advanced routes
The routes are found in `app/routes` and are yaml files that specify which controller and action belongs to a path. The path matchers are the same as used in [Sinatra](http://sinatrarb.com).

### Controllers
Each controller inherits from the application controller and has actions that are are mapped from the routes. You can access all of Rack's environment from here, in addition to session, cookie, flash and error objects.
```ruby
# Rack request
req
https://github.com/rack/rack/blob/master/lib/rack/request.rb

# You can leave out req. when calling methods
redirect('/')

# Rack response
res
https://github.com/rack/rack/blob/master/lib/rack/response.rb

# No need to write res. in front
headers['Content-Type', 'application/json']

# Rack environment hash
env

# Parameter hash
p
p[:name] => 'Winship'

# Session hash, secure cookies
s
s[:user] = user.key

# Cookies, normal cookies
c
c[:dialog] = 'login'

# Flash message hash
f
f[:info] = 'Logged in'
f[:error] = 'Please correct the errors belows'

# Error object
e
e.add(:name, 'Too short')
e.short
e.flat
e.full
e.any?
e.empty?
```

### Views and helpers
There is built in support for ERB, but you can easily add your own helpers. The helper modules go in the `app/helpers` directory and are automatically included and available in both controllers and views. There is support for layouts in the views as well. Add your layouts in `app/views/layout`.
```ruby
# Erb with layout. Your erb file should end with .erb
erb('root/home', :layout => 'default')

# Erb without layout, useful for partials from within other erb files
erb('root/home')
```
We've included some other useful helpers in `lib/susana/helpers.rb` as well.

### Models
The default Susana application doesn't use models as in a traditional MVC pattern, but you can add it if you want. The model files can be added to `app/models` and are automatically loaded. If you're looking for a fresh database ORM, take a look at [Mongocore](https://github.com/fugroup/mongocore).

### Validations and filters
Validations are included as modules in `app/validations`. This is because we want to validate the parameters instead of letting the model handle it. You can use the `e` object to add your errors, and use it in the controllers after:
```ruby
# In the validation module
def user_validation
  e.add(:name, 'Name is too short') if p[:name].blank?
end

# In the controller call the validation, then user the errors hash
user_validation
halt json(errors) if e.any?
```

The filters work in the same way, and are intended for redirecting, setup or access control.

### The App
Settings, database, sitemap, mail and regular expresssions are controlled in the App object, and are accessed using dot syntax. Here are some examples:

```ruby
# Look up settings from settings.yml
App.settings.url => 'https://www.fugroup.net'

# Insert a user into the database
App.db.users.set(:name => 'Vidar')

# Get the first user in the database
App.db.users.first

# Regenerate sitemap
App.sitemap.write

# Ping sitemap
App.sitemap.ping

# Send the hello email
App.mail.hello

# Use a regular expression
'file.jpg' => App.regex.image
```

Check out `lib/susana/app.rb` to see all the things that are included.

### Status
Everything is working but libraries are new, please report issues. Contributions are welcome.

MIT licensed.

`@authors: Vidar`
