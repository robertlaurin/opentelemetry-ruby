# frozen_string_literal: true

# Copyright The OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

require 'opentelemetry'

module OpenTelemetry
  module Instrumentation
    # Contains the OpenTelemetry instrumentation for the Faraday gem
    module Faraday
    end
  end
end

require_relative './faraday/instrumentation'
require_relative './faraday/version'
