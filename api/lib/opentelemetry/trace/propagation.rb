# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

require 'opentelemetry/trace/propagation/binary_format'
require 'opentelemetry/trace/propagation/trace_parent'
require 'opentelemetry/trace/propagation/context_keys'
require 'opentelemetry/trace/propagation/http_trace_context_extractor'
require 'opentelemetry/trace/propagation/http_trace_context_injector'
require 'opentelemetry/trace/propagation/job_trace_context_extractor'
require 'opentelemetry/trace/propagation/job_trace_context_injector'

module OpenTelemetry
  module Trace
    # The Trace::Propagation module contains injectors and extractors for
    # sending and receiving span context over the wire
    module Propagation
      extend self

      HTTP_TRACE_CONTEXT_EXTRACTOR = HttpTraceContextExtractor.new
      HTTP_TRACE_CONTEXT_INJECTOR = HttpTraceContextInjector.new
      RACK_HTTP_TRACE_CONTEXT_EXTRACTOR = HttpTraceContextExtractor.new(
        traceparent_header_key: 'HTTP_TRACEPARENT',
        tracestate_header_key: 'HTTP_TRACESTATE'
      )
      RACK_HTTP_TRACE_CONTEXT_INJECTOR = HttpTraceContextInjector.new(
        traceparent_header_key: 'HTTP_TRACEPARENT',
        tracestate_header_key: 'HTTP_TRACESTATE'
      )
      JOB_TRACE_CONTEXT_EXTRACTOR = JobTraceContextExtractor.new(
        traceparent_key: 'traceparent',
        tracestate_key: 'tracestate'
      )
      JOB_TRACE_CONTEXT_INJECTOR = JobTraceContextInjector.new(
        traceparent_key: 'traceparent',
        tracestate_key: 'tracestate'
      )
      BINARY_FORMAT = BinaryFormat.new

      private_constant :HTTP_TRACE_CONTEXT_INJECTOR, :HTTP_TRACE_CONTEXT_EXTRACTOR,
                       :RACK_HTTP_TRACE_CONTEXT_INJECTOR, :RACK_HTTP_TRACE_CONTEXT_EXTRACTOR,
                       :BINARY_FORMAT

      # Returns an extractor that extracts context using the W3C Trace Context
      # format for HTTP
      def http_trace_context_extractor
        HTTP_TRACE_CONTEXT_EXTRACTOR
      end

      # Returns an injector that injects context using the W3C Trace Context
      # format for HTTP
      def http_trace_context_injector
        HTTP_TRACE_CONTEXT_INJECTOR
      end

      def job_trace_context_extractor
        JOB_TRACE_CONTEXT_EXTRACTOR
      end

      def job_trace_context_injector
        JOB_TRACE_CONTEXT_INJECTOR
      end

      # Returns an extractor that extracts context using the W3C Trace Context
      # format for HTTP with Rack normalized keys (upcased and prefixed with
      # HTTP_)
      def rack_http_trace_context_extractor
        RACK_HTTP_TRACE_CONTEXT_EXTRACTOR
      end

      # Returns an injector that injects context using the W3C Trace Context
      # format for HTTP with Rack normalized keys (upcased and prefixed with
      # HTTP_)
      def rack_http_trace_context_injector
        RACK_HTTP_TRACE_CONTEXT_INJECTOR
      end

      # Returns a propagator for the binary format
      def binary_format
        BINARY_FORMAT
      end
    end
  end
end
