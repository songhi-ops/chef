
if node.chef_environment != '_default'
    remote_file "/usr/bin/ec2-metadata" do
        source "http://s3.amazonaws.com/ec2metadata/ec2-metadata"
        mode 0755
    end
end
