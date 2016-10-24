require 'capistrano_colors'

   capistrano_color_matchers = [
     { :match => /command finished/,       :color => :hide,      :prio => 10 },
     { :match => /executing command/,      :color => :blue,      :prio => 10, :attribute => :underscore },
     { :match => /^transaction: commit$/,  :color => :magenta,   :prio => 10, :attribute => :blink },
     { :match => /git/,                    :color => :white,     :prio => 20, :attribute => :reverse },
   ]

   colorize( capistrano_color_matchers )


require 'rvm/capistrano'
require 'bundler/capistrano'
require 'capistrano/ext/multistage'
require 'capistrano_colors'

before 'deploy:setup', 'rvm:install_rvm'

set :rvm_ruby_string , 'ruby-2.0.0-p195'
#set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,'') #- its for production

set :user, 'manio'
set :application, "datacol"
set :repository, "ssh://git@box99.2n.pl:33/datacol.git"

set :stages, %w(staging production)
set :default_stage, "staging"
set :deploy_via, :remote_cache # deploy only changes
set :use_sudo, false

set :scm, :git
ssh_options[:forward_agent] = true # connect by ssh key
set :branch, :master
default_run_options[:pty] = true


namespace :deploy do

  desc "Restart application"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Links the proper configuration files"
  task :update_symlinks do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{deploy_to}/shared/config/app_config.yml #{release_path}/config/app_config.yml"
    run "ln -nfs #{deploy_to}/shared/.rvmrc #{release_path}/.rvmrc"
  end

  task :load_schema, :roles => :app do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake db:schema:load"
  end

  task :seed, :roles => :app do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake db:seed"
  end

  after 'deploy:update_code' do
    update_symlinks
  end

  after "deploy", "deploy:cleanup"
end

namespace :rake do
  desc "test of list task on remote serwer"
  task :show_tasks do
    run("cd #{deploy_to}/current; rake -T")
  end
end