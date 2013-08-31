require 'spec_helper'
require 'sidekiq/statsd/server_middleware'

class DummyWorker; end
module DummyModule
  class DummyWorker; end
end

module Sidekiq::Statsd
  describe ServerMiddleware do
    let(:client) { double }
    let(:options) { Hash.new }

    subject(:middleware) { ServerMiddleware.new(client, options) }

    its(:client) { should == client }
    its(:prefix) { should == "sidekiq" }

    context 'being called' do
      let(:worker) do 
        DummyWorker.new
      end
      let(:msg) { { 'enqueued_at' => Time.now.to_f } }
      let(:queue) { double }

      context 'yielding the worker block' do
        it 'counts a success and times the duration' do
          client.should_receive(:time).with("sidekiq.dummy_worker.duration").and_yield
          client.should_receive(:timing).with("sidekiq.dummy_worker.latency", an_instance_of(Float))
          client.should_receive(:increment).with("sidekiq.dummy_worker.success")
          middleware.call(worker, msg, queue) { double }
        end
      end

      context 'raising in the worker block' do
        it 'counts a failure and times the duration' do
          client.should_receive(:timing).with("sidekiq.dummy_worker.latency", an_instance_of(Float))
          client.should_receive(:time).with("sidekiq.dummy_worker.duration").and_yield
          client.should_receive(:increment).with("sidekiq.dummy_worker.failure")
          expect { middleware.call(worker, msg, queue) { raise } }.to raise_error
        end
      end

      context 'without a nil enqueued_at key in the msg' do
        let(:msg) { Hash.new }

        it 'should not time the latency' do
          client.should_receive(:time).with("sidekiq.dummy_worker.duration").and_yield
          client.should_receive(:increment).with("sidekiq.dummy_worker.success")
          client.should_not_receive(:timing)
          middleware.call(worker, msg, queue) { double }
        end
      end
    end

    context 'with a prefix' do
      let(:options) { { :prefix => "foo"} }
      its(:prefix) { should == "foo" }

      context 'being called successfully' do
        let(:worker) do 
          DummyWorker.new
        end
        let(:msg) { { 'enqueued_at' => Time.now.to_f } }
        let(:queue) { double }

        it 'should count with the correct prefix' do
          client.should_receive(:time).with("foo.dummy_worker.duration").and_yield
          client.should_receive(:timing).with("foo.dummy_worker.latency", an_instance_of(Float))
          client.should_receive(:increment).with("foo.dummy_worker.success")
          middleware.call(worker, msg, queue) { double }
        end
      end
    end

    context 'with a worker class containing a namespace' do
      let(:worker) do 
        DummyModule::DummyWorker.new
      end
      let(:msg) { { 'enqueued_at' => Time.now.to_f } }
      let(:queue) { double }

      it 'should count with the correct prefix' do
        client.should_receive(:time).with("sidekiq.dummy_module.dummy_worker.duration").and_yield
        client.should_receive(:timing).with("sidekiq.dummy_module.dummy_worker.latency", an_instance_of(Float))
        client.should_receive(:increment).with("sidekiq.dummy_module.dummy_worker.success")
        middleware.call(worker, msg, queue) { double }
      end
    end
  end
end
