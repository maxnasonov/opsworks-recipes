execute 'removed stopped containers' do
    cwd '/docker-compose/'
    command '/usr/bin/docker rm $(/usr/bin/docker ps -a -q)'
    only_if '/usr/bin/docker ps -a -q'
end
