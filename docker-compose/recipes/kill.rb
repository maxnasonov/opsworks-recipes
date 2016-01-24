execute 'kill containers' do
    cwd '/docker-compose/'
    command 'docker-compose kill'
end
