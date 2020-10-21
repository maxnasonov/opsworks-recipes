python_pip 'awscli' do
  # Version that supports --no-include-email argument for aws ecr get-login
  # It should be 1.11.91+ for Docker 17.05+
  #version '1.11.120'
  action :install
end

execute "docker login" do
  command "$(/usr/local/bin/aws ecr get-login --region us-east-1 --no-include-email)"
  #sensitive true
end
