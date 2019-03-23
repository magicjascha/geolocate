# Geolocate

Small webserver app to get coordinates for a given address from openstreetmap. This project was just an exercise.

## Have a look at the app

At https://ancient-temple-97909.herokuapp.com you can find a sample.

Type in credentials for http authentication: username "sample_user" and password "sample_password".

You can either type in your address (e.g. "Checkpoint Charlie") or call the api directly with ```/locate?address=Checkpoint Charlie```


## Configure for production

Clone the project and install the gems from the gemfile

```bundle install```

The app is protected by a http basic authentication. In a production environment you have to set the credentials with environment variables auth_username and auth_password. (In development mode these are not configureable: username 'foo', password 'bar'). In production mode ssl is enforced to ensure those secrets are safe.

## Start the app

in the apps root folder run

```rackup```

or from anywhere

```rackup [path_to_apps_root_folder]/config.ru```

You can add option ```-p [portnumber]``` to choose another port.

## For Development

### Test

in the terminal you can run all tests at once with

```rake test```

or the single files in directory /test with

```ruby test/integration_test.rb```

