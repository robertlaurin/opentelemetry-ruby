module OpenTelemetry
  module SDK
    module Resources
      module Detectors
        class Telemetry
          def detect
            resource_labels = {}
            resource_labels[TELEMETRY_SDK_RESOURCE[:name]] = 'OpenTelemetry'
            resource_labels[TELEMETRY_SDK_RESOURCE[:language]] = 'ruby'
            resource_labels[TELEMETRY_SDK_RESOURCE[:version]] = "semver:#{OpenTelemetry::SDK::VERSION}"
            Resource.create(resource_labels)
          end
        end
      end
    end
  end
end
