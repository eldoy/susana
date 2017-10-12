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
- Models with validations
- MongoDB adapter and client
- Easy to use and customizable


### Installation
Susana can be cloned directly from here or installed using rubygems. You need ruby, mongodb and optionally graphicsmagick to run the default application. The default application comes complete with a few routes and user management.

[Click here for installation instructions](https://github.com/fugroup/susana/blob/master/gem/README.md)

### Philosophy
Susana is written from scratch on top of Rack, with inspiration from Rails and Sinatra. It's only a few hundred lines of code, but is more complete than Sinatra in that we include a curated collection of gems to provide you with everything you need. Just install, load the app and start coding your views, completely turnkey.

Every app is unique with different requirements. If you want to customize it, you can. We include all the code inside of your application and you can customize every part of it, no code is hidden inside gems. The source code is well documented and easy to understand.

### Configuration
Configuration files are found in the `config` directory. More info is found at the top of each file. The `config/boot.rb` file loads all of the gems, app files and the files in the `config/init` directory. The `config.ru` file sets up the middleware and runs the app.

### Locales and sitemap
The language translations are found in `config/locales`. Just add your file and it will be automatically loaded. Emails, routes and sitemap supports translations out of the box. For the routes, just add your two-character language, i.e. `/no`, `/es`, `/ru`, in front of the path. The sitemap entries can be added in `lib/susana/sitemap.rb`. Have a look at the sitemap section in `config/boot.rb` for options.

### Database
MongoDB is ready to use out of the box as long as you have mongod running on localhost. The `config/database.yml` lets you specify the connection. The [Mongocore client](https://github.com/fugroup/mongocore) is already integrated and connects automatically. Using a database has never been this easy.

### Email
Mail is sent via [Mailgun](https://mailgun.com) using our client. Set up your `mailgun_api_url` in `settings.yml` and you are ready to send emails. Your email templates are found in `app/views/mail` and also includes layout and support for translations. Mails are sent in the background in a separate thread.

### Code reloading
Once you start your application, all assets, ruby and yaml files are reloaded automatically so you see your changes immediately without having to restart the application. We've added autoload on most of the libraries included, so startup is fast as well.

### Advanced routes
The routes are found in `app/routes` and are yaml files that specify which controller and action belongs to a path. The path matchers are the same as used in [Sinatra](http://sinatrarb.com). Here are some example routes:
```yaml
# Maps to root controller home action
root#home:
  desc: App home
  path: /
  method: get   # Get is default, not needed

# Maps to project controller show action
# The :id in the path will give you a p[:id] parameter in the controller
project#show:
  desc: Project show
  path: /project/:id

# Maps to user controller session action
user#session:
  desc: User session
  path: r!/session   # Prefix with r! to use a regular expression
  method: post

# You can specify before, filters, validations and after in the route
user#update:
  desc: User update
  path: /update
  method: put
  before:
    - record_stats
  filters:
    - require_user_login
  validations:
    - email_validation
  after:
    - save_other_records
    - send_email_job

# You can also use yaml defaults to keep things dry
defaults: &defaults
  filters:
    - hello_filter

user#signup:
  desc: User signup
  path: /signup
  <<: *defaults
```
Any method is supported, including `get`, `post`, `put`, `delete`, `head`, `patch`, just add a `_method` parameter to your requests.

### Controllers
Each controller inherits from the application controller and has actions that are are mapped from the routes. You can access the Rack request, response and environment from here, in addition to session, cookie, flash and error objects.
```ruby
# Rack request
req
# https://github.com/rack/rack/blob/master/lib/rack/request.rb

# You can leave out req. when calling methods
redirect('/') instead of req.redirect('/')

# Rack response
res
# https://github.com/rack/rack/blob/master/lib/rack/response.rb

# No need to write res. in front
headers['Content-Type', 'application/json']

# Rack environment hash
env

# Parameter hash
p
p[:name] = 'Winship'
p[:name]

# Session hash, secure cookies
s
s[:user] = user.key
s[:user]

# Cookies, normal cookies
c
c[:dialog] = 'login'
c[:dialog]

# Flash message hash
f
f[:info] = 'Logged in'
f[:error] = 'Please correct the errors belows'

# Error object
e
e.add(:name, 'Too short')
e[:name]
e.join(:name)
e.short
e.flat
e.full
e.any?
e.empty?

# View helper for errors
r(:name)
```

### Views and helpers
There is built in support for ERB, but you can easily add your own helpers. The helper modules go in the `app/helpers` directory and are automatically included and available in both controllers and views. There is support for layouts in the views as well. Add your layouts in `app/views/layout`.
```ruby
# Erb with layout. Your erb file should end with .erb
erb('root/home', :layout => :default)

# Erb without layout, useful for partials from within other erb files
erb('root/home')
```
We've included some other useful helpers in `lib/susana/helpers.rb` as well.
```ruby
# Convert to json and set correct content type. Perfect for API's or ajax.
json(:name => p[:name])

# Immediately stop execution and write response
halt(200)
halt(404, "Not found\n")
halt("World amazing.")

# Translations
t('user.login.name')

# Time localizations
l(Time.now)

# HTTP Basic login protection, add to top of controller action
# Set your username and password in config/settings.yml
protect!
```

### Models
The default Susana application uses models as in a traditional MVC pattern, but you can also use it without. The model files can be added to `app/models` and are automatically loaded. We are using our own fresh mongodb ORM, [Mongocore.](https://github.com/fugroup/mongocore)

### Background queue
The `lib/jobs` directory includes your background tasks. They are based on the [sucker_punch gem](https://github.com/brandonhilkert/sucker_punch) and works in a separate thread to make your long running tasks seem faster.

### Validations, filters, before and after
Validations are included as modules in `app/validations`. These are validations you can run before the route hits the controller action. You can use the `e` object to add your errors, and use it in the controllers after:
```ruby
# In the validation module
def user_validation
  e.add(:name, 'Name is too short') if p[:name].blank?
end

# In the controller call the validation, and then we can use the errors hash
user_validation
halt json(errors) if e.any?
```

The filters in `app/filters` work in the same way, and are intended for redirecting, setup or access control. They are run before the validations. You can call them directly from the controller action, or set them up to be called automatically from the route.

In addition you can specify `before` and `after` which will run before and after the action. See the *Advanced routes* section above for more info.

### Assets
Your assets live in `app/assets` and are served by our [asset middleware](https://github.com/fugroup/asset). This asset manager compresses your CSS and Javascript in production, and makes sure your images are served fast as well.

### Uploads
We've included the [pushfile gem](https://github.com/fugroup/pushfile) for file uploads. Set up your account info in `config/pushfile.yml` to upload files to Amazon or Rackspace. Images are resized automatically using GraphicsMagick.

### The App
Settings, database, sitemap, mail and regular expresssions are controlled in the App object, and are accessed using dot syntax. In the controllers, helpers and views, there is no need to prefix with `App.`. Here are some examples:

```ruby
# Look up settings from settings.yml
App.settings.url => 'https://www.fugroup.net'

# In controllers, helpers and views you can skip the App. prefix
settings.url

# Raw mongodb connection
db[:users].find.first

# Regenerate sitemap
sitemap.write

# Ping sitemap
sitemap.ping

# Send the hello email
mail.hello

# Use a regular expression
'file.jpg' => regex.image

# Threaded request store
store[:count] = 1
```

Check out `lib/susana/app.rb` to see all the things that are included. You will love making apps with Susana.

### Status
Everything is working but libraries are new, please report issues. Contributions are welcome.

MIT licensed.

`@authors: Vidar`
