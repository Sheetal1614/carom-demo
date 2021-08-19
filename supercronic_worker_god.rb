God.watch do |w|
  w.name   = "supercronic-worker-1"
  # w.dir    = '/path/to/app/dir'
  # w.dir    = '/app'
  w.dir    = '.'
  # w.env = { 'PADRINO_ENV' => 'production', 'QUEUES' => 'newsletter-sender,push-message' }
  w.group    = 'supercronic-workers'
  w.interval = 30.seconds
  w.start = "supercronic -split-logs ./carom-crontab 2>&1"
  # w.start = "supercronic -split-logs ./carom-crontab 1>./log/cron.log"
  w.stop = "ps axf | grep \"supercronic -split-logs\" | grep -v grep | awk '{print \"kill -9 \" $1}' | sh"
  # w.log   = "/var/log/god/supercronic-worker-1.log" #That means logging on STDOUT

  # restart if memory gets too high
  w.transition(:up, :restart) do |on|
    on.condition(:memory_usage) do |c|
      c.above = 1.gigabytes #50.megabytes
      c.times = 3
    end
  end

  # determine the state on startup
  w.transition(:init, { true => :up, false => :start }) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
  end

  # determine when process has finished starting
  w.transition([:start, :restart], :up) do |on|
    on.condition(:process_running) do |c|
      c.running = true
      c.interval = 5.seconds
    end

    # failsafe
    on.condition(:tries) do |c|
      c.times = 5
      c.transition = :start
      c.interval = 5.seconds
    end
  end

  # start if process is not running
  w.transition(:up, :start) do |on|
    on.condition(:process_running) do |c|
      c.running = false
    end
  end
end