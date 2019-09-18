# Docs: https://guides.rubyonrails.org/active_job_basics.html
# To generate a job file, run: rails g job <job-name>

# To start a worker to run jobs from your queue, run
# rails jobs:work (in a seperate terminal/tab)

class HelloWorldJob < ApplicationJob
  queue_as :default

  # When a job is executed, the "perform" method will be called
  def perform(*args)
    puts "--------------------------"
    puts "---- Running Job ----"
    puts "--------------------------"
  end
  # To run a job, use any of the following methods:

  # <JobClass>.perform_now(<args>)
  # This will run the job synchronously (or in the foreground)
  # meaning that it will not be in the queue.
  # Rails would execute the job instead of a worker.

  # <JobClass>.perform_later(<args>)
  # This will insert the job in your queue to be executed by a worker.

  # To perform jobs at a given time, use '.set':
  # <JobClass>.set(<some-kind-of-time>)

  # HelloWorldJob.set(wait: 10.minutes).perform_later
  # The above will insert a job in the queue that will only run after 10minutes have passed. 

  # HelloWorldJob.set(run_at: 1.week.from_now).perform_later

  
end
