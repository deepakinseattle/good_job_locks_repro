class LocksReproJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "Performing #{args} at #{Time.zone.now}"
    sleep 0.5
    puts "Performed #{args} at #{Time.zone.now}"
  end
end
