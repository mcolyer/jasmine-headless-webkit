require 'tilt/template'

module Jasmine::Headless
  class JSTemplate < Tilt::Template
    include Jasmine::Headless::FileChecker
    self.default_mime_type = 'application/javascript'

    def prepare ; end

    class JSCacheable < CacheableAction
      class << self
        def cache_type
          "javascript"
        end
      end

      def initialize(file, data)
        @file = file
        @data = data
      end

      def action
        @data
      end
    end

    def evaluate(scope, locals, &block)
      if bad_format?(file)
        alert_bad_format(file)
        return ''
      end
      cache = JSCacheable.new(file, data)
      source = cache.handle
      if cache.cached?
        %{<script type="text/javascript" src="#{cache.cache_file}"></script>
          <script type="text/javascript">window.CSTF['#{File.split(cache.cache_file).last}'] = '#{file}';</script>}
      else
        %{<script type="text/javascript">#{source}</script>}
      end
    end
  end
end

