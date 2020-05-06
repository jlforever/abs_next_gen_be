## ABS next gen backend README

This README doc will describe how the ABS next generation backend repository will be setup.

### Clone the repository

```
git clone git@github.com:jlforever/abs_next_gen_be.git
```

### Installing Ruby

We use `rbenv` to install ruby. Current the repository's appropriate ruby version is locked at `2.5.3`

<b>Take a look at your current rbenv installed rubies</b>

```
rbenv versions
```

If above is not pointing to `2.5.3` (at any patch level), then

<b>Perform the rbenv install</b>

```
rbenv install 2.5.3
```

<b>Lock local to 2.5.3 and rehash</b>

```
rbenv local 2.5.3
rbenv rehash
```

### Install bundler & bundle

Our repo's currently locked in bundler is at 2.1.4

```
gem install bundler -v '2.1.4'
```

now we are ready to install the dependent gems

```
bundle install
```

### Install postgres and redis

Our locked in postgres is at `v10.3` and our redis is at at `v4.0.6`

Please feel free to use `homebrew` to install both


### Prepare local database

Create the local development and test database and run migrations

``` 
bundle exec rake db:create
bundle exec rake db:migrate db:test:prepare --trace
```

### Run rails with puma

```
rackup
```

now rails should be served on `localhost:9292`