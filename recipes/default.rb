# frozen_string_literal: true
#
# Cookbook Name:: rsc_remote_recipe
# Recipe:: default
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

raise "node['rightscale']['refresh_token'] is not set.  Add the RightScale API "\
      'Refresh Token to continue.' if node['rightscale']['refresh_token'].nil?
raise "node['rightscale']['api_url'] is not set.  Add the RightScale API URL "\
      'to continue.' if node['rightscale']['api_url'].nil?

node.default['build-essential']['compile_time'] = true
include_recipe 'build-essential'

# log "Installing 'right_api_client' gem"
chef_gem 'right_api_client'
