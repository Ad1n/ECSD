# ECSD

Simple service for generate ec2_sd config files (one file per cluster) 
to allow ECS cluster to be discovered by prometheus monitoring service.

Warning! Tested only with EC2 cluster model. 
Working with fargate cluster model is not guaranteed

## Getting started

First create AWS IAM user with roles for describe and list.

Then add gem to your service:
```ruby
gem 'ECSD', '~> 1.1.0'
```
Or install directly:
```
$ gem install ECSD
```

To start discover ECS cluster define config:
```ruby
require 'ECSD'

ECSD.config do |c|
  c.clusters = %w[cluster_name]
  c.region = 'region'
  c.credentials = { AWS_ACCESS_KEY_ID: 'ID', AWS_SECRET_ACCESS_KEY: 'SECRET' }
  c.options = { 
    export_path: '/dir/path/to/export/folder',
    timeout: 101
  }
  c.logger = Logger.new($stdout)
end
```

- `clusters` - array of cluster names to discover. Same name as ECS cluster
- `region` - AWS region name where ECS cluster deployed
- `credentials` - `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` from your IAM user
- `options`
    - `export_path` - path to export config folder. Default is `#{service root}/export`
    - `timeout` - time in seconds between cluster discovery cycles.
- `logger` - define your logger or default logger will be set

Then start discover:
```ruby
ECSD.start
```
By default ECSD continuously discovering defined clusters and save templates into
corresponded files.

Also it's possible to start only one cycle discover:
```ruby
ECSD.start(cycle: false)
```

## Contributing

[Fork the project](https://github.com/Ad1n/ECSD) and send pull
requests.