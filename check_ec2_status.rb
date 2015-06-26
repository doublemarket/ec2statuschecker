require 'aws-sdk-core'
require 'yaml'
require 'optparse'

params = {
  instance_file: "/tmp/instances.yaml",
  region:  "us-east-1"
}
OptionParser.new do |opt|
  opt.on("-a access_key", "AWS Access Key"){|v| params[:access_key_id] = v}
  opt.on("-s secret_key", "AWS Secret Access Key"){|v| params[:secret_access_key] = v}
  opt.on("-f datafile", "File path for storing past data"){|v| params[:lb_file] = v}
  opt.on("-r regionname", "Region name"){|v| params[:region] = v}
  opt.parse!(ARGV)
end

aws_config = {}
aws_config.update access_key_id: params[:access_key_id], secret_access_key: params[:secret_access_key] if params[:access_key_id] && params[:secret_access_key]
aws_config.update region: params[:region]

ec2 = Aws::EC2::Client.new(aws_config)

if File.exist?(params[:instance_file])
  past_instances = YAML.load_file(params[:instance_file])
else
  p "No data file found. This seems first run."
  past_instances = {}
end

instances = {}
ec2.describe_instance_status.instance_statuses.each do |i|
  instances[i.instance_id] = i.instance_state.name
end

open(params[:instance_file], "w") do |f|
  YAML.dump(instances, f)
end

if ! instances.eql? past_instances and past_instances.length > 0
  instances.each_key do |id|
    if instances[id] != past_instances[id]
      instance_name = ec2.describe_instances({instance_ids: [id]}).reservations[0].instances[0].tags.select{|t| t.key == "Name"}[0].value
      puts "#{id} (#{instance_name}) state changed #{past_instances[id]} -> #{instances[id]}"
    end
  end
end

