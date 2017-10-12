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

    # Generate a token and make sure it's unique
    def self.generate_token(coll, field = :token)
      begin
        token = SecureRandom.urlsafe_base64
      end while App.db[coll].find(field => token).first
      token
    end

  end
end
