# Gploy

This RubyGem can be used to deploy Ruby on Rails application.
**NOTE** under development, and incomplete yet

## Installation

Add this line to your application's Gemfile:

    gem 'gploy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gploy

## Usage

First, you need your project under git and available in some repository, like github.
Is not necessary to use within your project. If you have a directory with following structure:

	>some_folder
		-> config/gploy.yml

With this, is now possible deploy your app. The gploy.yml file should be as:

	ruby_env:
	  rake: /user/.rbenv/versions/1.9.3-p194/bin/rake

	deploy:
	  url:    localhost
	  user:   root
	  password: secret
	  app_name: my_app
	  repo: https://github.com/edipofederle/blog.git
	  path: /var/www/apps
	  number_releases: 3

	tasks:
	  dbmigrate:   RAILS_ENV=production rake db:migrate


The *number_releases* is the number of version of deployments you want keep into server. 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
