# frozen_string_literal: true

# Copyright 2020 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

module OpenTelemetry
  module Adapters
    module Sidekiq
      module Middlewares
        module Client
          class TracerMiddleware
            def call(worker_class, job, _queue, _redis_pool)
              tracer.in_span(
                worker_class,
                attributes: job,
                kind: :client
              ) do |span|
                yield
              end
            end

            private

            def tracer
              Sidekiq::Adapter.instance.tracer
            end
          end
        end
      end
    end
  end
end