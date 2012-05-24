require 'tilt/template'
require 'erb'

module Jasmine::Headless
  class ERBTemplate < Tilt::Template
    include Jasmine::Headless::FileChecker

    self.default_mime_type = 'application/javascript'

    def prepare ; end

    module ErbHelpers
      # Stub out the asset_path helper
      def asset_path(str)
        "/assets/#{str}"
      end
    end

    def evaluate(scope, locals, &block)
      if bad_format?(file)
        alert_bad_format(file)
        return ''
      end
      begin
        ERB.new(File.read(file)).result(ErbHelpers.instance_eval { binding })
      rescue StandardError => e
        puts "[%s] Error in compiling file: %s" % [ 'erb'.color(:red), file.color(:yellow) ]
        raise e
      end
    end
  end
end

