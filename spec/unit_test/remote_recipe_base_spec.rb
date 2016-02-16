#
# Cookbook Name:: remote_recipe
# Spec:: remote_recipe_base_spec
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

require 'spec_helper'

describe Chef::RemoteRecipeBase do
  MAX_SLEEP_INTERVAL = 60

  let(:base) { Chef::RemoteRecipeBase.new }

  before do
    Kernel.stub(:sleep) {|seconds| seconds}
  end

  describe '#sleep_interval' do
    it "should return interval less than or equal to #{MAX_SLEEP_INTERVAL} seconds" do
      interval = base.send(:sleep_interval, 1)
      interval.should eq(2)

      interval = base.send(:sleep_interval, 4)
      interval.should eq(16)

      interval = base.send(:sleep_interval, 80)
      interval.should == MAX_SLEEP_INTERVAL
    end
  end






end
