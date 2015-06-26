# ec2statuschecker

Checks status change of all instances in a specific region.

## How to install

```
$ git clone https://github.com/doublemarket/ec2statuschecker.git
$ cd ec2statuschecker
$ bundle install --path=vendor/bundle
$ bundle exec ruby check_ec2_state.rb
```

## Options

- -a ACCESS_KEY : AWS Access Key
- -s SECRET_KEY : AWS Secret Access Key
  - If you don't specify ACCESS_KEY and SECRET_KEY, the script try to use configuration in ~/.aws directory
- -f DATA_FILE : File path for storing past status data
  - default : /tmp/instances.yaml
- -r REGION : Region name
  - default : us-east-1

