# sidekiq_statsd_middleware

A Ruby gem that provides a server middleware component for Sidekiq that sends
worker success and failure counts, and job timing information to StatsD.

## Usage

    statsd_client = Statsd.new

    Sidekiq.configure_server do |config|
      config.server_middleware do |chain|
        chain.add Sidekiq::Statsd::ServerMiddleware, statsd_client, prefix: "app.production.sidekiq"
      end
    end

When a worker with the class of, say, `MyBigJob` executes, you'll see a StatsD
count appear with the name `app.production.sidekiq.my_big_job.success` or
`app.production.sidekiq.my_big_job.failure`. The execution timing for the job
will appear as `app.production.sidekiq.my_big_job.duration` and the latency
(the time difference between when the job was queued and when the job was executed
by the worker), will appear as `app.production.sidekiq.my_big_job.latency`. 

## License

Copyright (C) 2013 Tom Taylor

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
