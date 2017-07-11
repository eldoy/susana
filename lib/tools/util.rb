# Add shared utility methods here
module Susana
  class Util

    # Render erb template
    def self.erb(path, options = {})
      template = Tilt['erb'].new(path)
      render = template.render(self, options[:locals])

      # Return render unless options[:layout] is set
      return render unless options[:layout]

      # Render with layout
      layout = Tilt['erb'].new(options[:layout])
      layout.render(self, options[:locals]) { render }
    end

  end
end
