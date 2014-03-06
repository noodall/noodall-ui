# noodall-ui

## Asset Storage

There are three options for asset storage - Amazon S3, Mongo GridFS or the local filesystem.

If you're using S3 you need to add fog to the app's Gemile and configure the data store:

```ruby
gem 'fog'
```

Set `app.datastore` in `config/initializers/dragonfly.rb`

Instructions for setting up an S3 bucket can be found [here](S3.md).

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Steve England. See LICENSE for details.
