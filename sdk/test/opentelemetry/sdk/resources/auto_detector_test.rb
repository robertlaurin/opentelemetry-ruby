# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

require 'test_helper'

describe OpenTelemetry::SDK::Resources::AutoDetector do
  let(:auto_detector) { OpenTelemetry::SDK::Resources::AutoDetector.new }

  describe '#detect' do
    it 'returns detected resources' do
      _(auto_detector.detect).must_be_instance_of(OpenTelemetry::SDK::Resources::Resource)
    end
  end
end
