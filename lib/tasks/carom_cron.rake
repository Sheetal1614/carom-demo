namespace :carom do

    task :provision_cron => [:environment] do |t, args|
        _cron_file = 'carom-crontab'

        File.delete(_cron_file) if File.exist?(_cron_file)

        File.open(_cron_file, "w") do |file|
            Poke.group(:frequency).count.keys.each do |_cron_expression|
                # file.puts([_cron_schedule, "echo \"Sample Hello on #{_cron_name}\""].join(' '))
                file.puts([_cron_expression, "bundle exec rake \"carom:poke[#{_cron_expression}]\""].join(' '))
            end
        end

        puts `god restart supercronic-workers`
    end

    #TODO: In future will need to implement thread if pokes grow big in numbers.
    task :poke, [:frequency] => [:environment] do |t, args|
        Rails.logger.debug "Frequency is #{args.frequency} @ #{Time.now}"
        Poke.where(frequency: args.frequency).where(live: true).each { |poke| poke.do }
    end

    # task :name, [:first_name, :last_name] => [:environment] do |t, args|
    #   args.with_defaults(:first_name => "John", :last_name => "Dough")
    #   puts "First name is #{args.first_name}"
    #   puts "Last  name is #{args.last_name}"
    # end

end
