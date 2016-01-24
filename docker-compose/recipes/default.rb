require "aws"

package 'docker' do
  action :install
end

service 'docker' do
    supports restart: true, reload: true
    action %w(enable start)
end

package 'python-pip'

python_pip "docker-compose"

include_recipe 'docker-compose::cron'
include_recipe 'docker-compose::login'
