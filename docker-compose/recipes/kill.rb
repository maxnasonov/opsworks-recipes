execute 'kill all running containers' do
    cwd '/docker-compose/'
    command '/usr/bin/docker kill $(/usr/bin/docker ps -a -q)'
end
