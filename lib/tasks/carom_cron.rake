namespace :carom do

  task :provision_cron => [:environment] do |t, args|
    File.open('carom-crontab', "w") do |file|
      Poke::FREQUENCY_SET.each do |_cron_name, _cron_schedule|
        # file.puts([_cron_schedule, "echo \"Sample Hello on #{_cron_name}\""].join(' '))
        file.puts([_cron_schedule, "bundle exec rake \"carom:poke[#{_cron_name}]\""].join(' '))
      end
    end

    puts `god restart supercronic-workers`
  end

  task :poke, [:frequency] => [:environment] do |t, args|
    Rails.logger.debug "Frequency is #{args.frequency} @ #{Time.now}"
    Poke.where(frequency: args.frequency).where(live: true).each {|poke| poke.do}
  end

  # task :name, [:first_name, :last_name] => [:environment] do |t, args|
  #   args.with_defaults(:first_name => "John", :last_name => "Dough")
  #   puts "First name is #{args.first_name}"
  #   puts "Last  name is #{args.last_name}"
  # end

end
