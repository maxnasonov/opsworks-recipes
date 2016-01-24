execute 'stop containers' do
    cwd '/docker-compose/'
    command 'docker-compose stop'
end
