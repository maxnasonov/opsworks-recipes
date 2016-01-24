execute 'up containers' do
    cwd '/docker-compose/'
    command 'docker-compose up -d'
end
