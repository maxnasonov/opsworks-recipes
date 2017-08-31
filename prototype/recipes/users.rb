require 'aws-sdk'

aws_s3_file "/opt/mellon/users.conf" do
  bucket "rm-prototype-certificates-us-east-1"
  remote_path "users.conf"
end

