# Geolocate

Small webserver app to get coordinates for a given address from openstreetmap. This is just an exercise.

## Configure

The app is protected by a http basic authentication. In a production environment you have to set the credentials with environment variables auth_username and auth_password. In development mode these are: username 'foo', password 'bar'.

## Start the app

in the apps root folder run

```rackup```

you can add option ```-p [portnumber]``` to choose another port.

## Use

Type in credentials for http authentication (in development mode username 'foo', password 'bar')

You can either type in your address (e.g. "Checkpoint Charlie") at ```/search``` or call the api directly with ```/locate?address=Checkpoint Charlie```

## For Development

# Test

in the terminal you can run all tests at once with

```rake test```

or the single files in directory /test with

```ruby test/integration_test.rb```

