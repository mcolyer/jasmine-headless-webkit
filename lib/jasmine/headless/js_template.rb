require 'tilt/template'

module Jasmine::Headless
  class JSTemplate < Tilt::Template
    include Jasmine::Headless::FileChecker
    self.default_mime_type = 'application/javascript'

    def prepare ; end

    def evaluate(scope, locals, &block)
      if bad_format?(file)
        alert_bad_format(file)
        return ''
      end
      if data[%r{^<script type="text/javascript"}]
        data
      else
        %{<script type="text/javascript">#{data}</script>}
      end
    end
  end
end

