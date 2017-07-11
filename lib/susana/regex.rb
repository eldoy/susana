# Regex collection for use in application

module Susana
  class Regex

    # Add language in front of the path to translate
    def locale
      %r{^\/(#{(I18n.available_locales - [I18n.default_locale]).join('|')})}
    end

    # Image regexp, full url including protocol
    def image
      /http[s]?:\/\/.+(\.(jpg|jpeg|png|gif|bmp))$/i
    end

    # Image regexp, just extension
    def extimage
      /^.+(\.(jpg|jpeg|png|gif|bmp))$/i
    end

    # Vimeo video urls
    def vimeo
      /http[s]?:\/\/(www\.)?vimeo.com\/(\d+)/
    end

    # Youtube video urls
    def youtube
      /http[s]?:\/\/(www\.)?(youtu.be\/|youtube.com\/watch\?v=)(\S+)/
    end

    # Facebook video urls
    def facebook
      /http[s]?:\/\/((www|web|m)\.)?facebook.com\/[A-z0-9]{2,}\/videos\/(\d+)\/?/
    end

    # Email address
    def email
      /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,16}\z/
    end

    # Integer
    def int
      /^\d+$/
    end

    # Float
    def float
      /^(\d*[.])?\d+$/
    end

  end
end
