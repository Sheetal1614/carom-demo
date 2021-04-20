#! /bin/sh
echo "Creating tmp/pids..."
mkdir -p tmp/pids/

DIR="/gem_playground/"
if [ -d "$DIR" ]; then
  # Take action if $DIR exists. #
  echo "Copying Gemfile to source code..."
  cp -rf /gem_playground/Gemfile* .
fi

echo "Generating git info"
echo "Branch: $(git rev-parse --abbrev-ref HEAD)" > git.info
git log -n 1 >> git.info

echo "Running db creation"
bundle exec rake db:create

echo "Running db's migration..."
bundle exec rake db:migrate

#echo "Running db's seed..."
#bundle exec rake db:seed

echo "Starting 'god' which keeps eye on supercronic worker (running using raketask)"
god -c supercronic_worker_god.rb
bundle exec rake carom:provision_cron

# Start Application
echo "Starting up puma(app server)..."
bundle exec puma -C config/puma.rb