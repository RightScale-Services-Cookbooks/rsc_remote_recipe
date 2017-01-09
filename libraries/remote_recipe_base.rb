#
# Cookbook Name:: remote_recipe
# Library:: remote_recipe_base
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

class Chef
  class RemoteRecipeBase
    # Default query timeout (in seconds)
    #
    DEFAULT_QUERY_TIMEOUT = 120 unless const_defined?(:DEFAULT_QUERY_TIMEOUT)

    # Maximum value for sleep interval (in seconds) when re-querying tags
    #
    MAX_SLEEP_INTERVAL = 60 unless const_defined?(:MAX_SLEEP_INTERVAL)

    # Run recipe on a server.
    #
    # @param name [String] the recipe to run
    #
    def run(_name)
      not_implemented
    end

    private

    # Use the RemoteRecipe.factory method to create this class.
    #
    def initalize; end

    # Calculates the interval for re-querying tags. For every re-query the interval
    # is increased exponentially until the interval reaches the maximum limit of
    # `MAX_SLEEP_INTERVAL`.
    #
    # @param delay [Integer] the current sleep interval
    #
    # @return [Integer] the new sleep interval
    #
    def sleep_interval(delay)
      return 2 if delay == 1
      [delay * delay, MAX_SLEEP_INTERVAL].min
    end

    # Raises an error if the method called is not implemented in the class.
    #
    # @raise [NotImplementedError] if the method call is not implemented
    #
    def not_implemented
      caller[0] =~ /`(.*?)'/
      raise NotImplementedError, "#{Regexp.last_match(1)} is not implemented on #{self.class}"
    end
  end
end
