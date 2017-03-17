# frozen_string_literal: true
#
# Cookbook Name:: remote_recipe
# Spec:: spec_helper
#
# Copyright (C) 2013 RightScale, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

lib = File.expand_path('../../libraries', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'chefspec'
require 'chefspec/berkshelf'
require 'remote_recipe'
require 'provider_remote_recipe'
require 'resource_remote_recipe'

ChefSpec::Coverage.start!

RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '12.04'
  config.log_level = :error
end
