server "box98.2n.pl", :app, :web, :db, primary: true
set :branch, 'master'
set :user, 'manio'
set :deploy_to, "/home/manio/apps/DataCol"
set :deploy_env, 'staging'
set :rails_env, 'staging'
set :port, 33