module Susana

  # Serve static files
  class Files

    # Init
    def initialize(app)
      @app = app
    end

    # Call
    def call(env)
      path = env['PATH_INFO']

      case path
      when /^\/api\//
        @app.call(env)
      when /^\/sitemap\.xml$/
        sitemap = File.read("#{App.views}/root/sitemap.xml")
        [200, {'Content-Type' => 'application/xml;charset=utf-8', 'Content-Length' => sitemap.bytesize}, [sitemap]]
      else
        path = '/index.html' if File.extname(path) == ''
        path = "#{App.root}/public#{path}"

        # Check if file exists
        if ::File.file?(path) and ::File.readable?(path)
          file = ::File.open(path, 'r:UTF-8', &:read)
          ext = ::File.extname(path)
          last_modified = ::File.mtime(path).httpdate
          return [304, {}, []] if env['HTTP_IF_MODIFIED_SINCE'] == last_modified
          type = "#{Rack::Mime.mime_type(ext)}; charset=utf-8"
          [200, {'Content-Type' => type, 'Content-Length' => file.bytesize, 'Last-Modified' => last_modified}, [file]]
        else
          message = "Not found: #{path}"
          [404, {'Content-Type' => 'text/html; charset=utf-8', 'Content-Length' => message.bytesize}, [message]]
        end
      end
    end
  end
end
