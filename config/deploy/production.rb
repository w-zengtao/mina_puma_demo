puts 'using production'

set :domain, 'production_server_ip'
set :user, 'deploy'
set :deploy_to, '/opt/rails_staging'
set :repository, 'git@git.coding.net:soizt/mina_puma_deploy.git'
set :branch, 'production'
set :rails_env, 'production'
