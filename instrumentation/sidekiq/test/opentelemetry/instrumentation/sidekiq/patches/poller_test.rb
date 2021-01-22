# frozen_string_literal: true

# Copyright The OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

require 'test_helper'

require 'opentelemetry-instrumentation-redis'
require 'fakeredis/minitest'

require_relative '../../../../../lib/opentelemetry/instrumentation/sidekiq'
require_relative '../../../../../lib/opentelemetry/instrumentation/sidekiq/patches/poller'

describe OpenTelemetry::Instrumentation::Sidekiq::Patches::Poller do
  let(:instrumentation) { OpenTelemetry::Instrumentation::Sidekiq::Instrumentation.instance }
  let(:redis_instrumentation) { OpenTelemetry::Instrumentation::Redis::Instrumentation.instance }
  let(:exporter) { EXPORTER }
  let(:spans) { exporter.finished_spans }
  let(:span) { spans.first }
  let(:config) { {} }

  before do
    # Clear spans
    exporter.reset
    redis_instrumentation.install
    instrumentation.install(config)
  end

  after do
    # Force re-install of instrumentation
    redis_instrumentation.instance_variable_set(:@installed, false)
    instrumentation.instance_variable_set(:@installed, false)
  end

  describe '#enqueue' do
    it 'does not trace' do
      ::Sidekiq::Scheduled::Poller.new.enqueue
      _(spans.size).must_equal(0)
    end

    describe 'when enqueue tracing is enabled' do
      let(:config) { { trace_poller_enqueue: true } }

      it 'traces' do
        poller = ::Sidekiq::Scheduled::Poller.new.enqueue
        span_names = spans.map(&:name)
        _(span_names).must_include('Sidekiq::Scheduled::Poller#enqueue')
        _(span_names).must_include('ZRANGEBYSCORE')
      end
    end
  end

  describe '#wait' do
    it 'does not trace' do
      poller = ::Sidekiq::Scheduled::Poller.new
      poller.stub(:random_poll_interval, 0.0) do
        poller.send(:wait)
      end

      _(spans.size).must_equal(0)
    end

    describe 'when wait tracing is enabled' do
      let(:config) { { trace_poller_wait: true } }

      it 'traces' do
        poller = ::Sidekiq::Scheduled::Poller.new
        poller.stub(:random_poll_interval, 0.0) do
          poller.send(:wait)
        end

        span_names = spans.map(&:name)
        _(span_names).must_include('Sidekiq::Scheduled::Poller#wait')
      end
    end
  end
end
