#! /bin/sh

# Running asset precompilation (as there is no volume mount and it gives permissions error)
echo "Running rake assets:clean..."
bundle exec rake assets:clean

echo "Running rake assets:clobber..."
bundle exec rake assets:clobber

echo "Running rake assets:environment..."
bundle exec rake assets:environment

echo "Running rake assets:precompile..."
bundle exec rake assets:precompile

echo "Running db's migration..."
bundle exec rake db:migrate

#echo "Running db's seed..."
#bundle exec rake db:seed

echo "Starting 'god' which keeps eye on backburner worker (beanstalk based active job worker) (running using raketask)"
god -c supercronic_worker_god.rb
bundle exec rake carom:provision_cron

# Start Application
echo "Starting up puma(app server)..."
bundle exec puma -C config/puma.rb