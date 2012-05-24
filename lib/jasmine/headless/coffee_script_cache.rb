require 'coffee_script'
require 'digest/sha1'
require 'fileutils'

module Jasmine
  module Headless
    class CoffeeScriptCache < CacheableAction
      class << self
        def cache_type
          "coffee_script"
        end
      end

      def initialize(file, data)
        @file = file
        @data = data
      end

      def action
        CoffeeScript.compile(@data)
      end
    end
  end
end

