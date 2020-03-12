# frozen_string_literal: true

# Copyright 2020 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

module OpenTelemetry
  module Adapters
    module Sidekiq
      module Middlewares
        module Server
          class TracerMiddleware
            def call(_worker, msg, _queue)
              tracer.in_span(
                msg['class'],
                attributes: msg,
                kind: :server
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
