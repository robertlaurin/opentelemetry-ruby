# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

require 'opentelemetry/sdk/resources/detectors/google_cloud_platform'
require 'opentelemetry/sdk/resources/detectors/telemetry'

module OpenTelemetry
  module SDK
    module Resources
      class AutoDetector
        DETECTORS = [
          OpenTelemetry::SDK::Resources::Detectors::GoogleCloudPlatform.new,
          OpenTelemetry::SDK::Resources::Detectors::Telemetry.new,
        ]

        def initialize(initial_resource = OpenTelemetry::SDK::Resources::Resource.create)
          @initial_resource = initial_resource
        end

        def detect
          DETECTORS.each do |detector|
            new_resource = detector.detect();
            @initial_resource = @initial_resource.merge(new_resource)
          end
          @initial_resource
        end
      end
    end
  end
end
