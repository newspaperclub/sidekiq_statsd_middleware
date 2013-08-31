require 'active_support/core_ext/string/inflections'

module Sidekiq
  module Statsd
    class ServerMiddleware

      attr_reader :client, :prefix

      def initialize(client, options = {})
        @client = client
        @prefix = options.delete(:prefix) || "sidekiq"
      end

      def call(worker, msg, queue)
        if msg['enqueued_at']
          latency = Time.now.to_f - msg['enqueued_at']
          client.timing(metric_key(worker, "latency"), latency)
        end

        client.time(metric_key(worker, "duration")) do
          yield
        end

        client.increment(metric_key(worker, "success"))
      rescue => e
        client.increment(metric_key(worker, "failure"))
        raise e
      end

      private

      def metric_key(worker, key)
        worker_name = worker.class.name.underscore.gsub("/", ".")
        [prefix, worker_name, key].reject(&:nil?).join(".")
      end
    end
  end
end

