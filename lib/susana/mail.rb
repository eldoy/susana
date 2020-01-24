# Sends emails for your app
# Example: App.mail.hello(:to => 'vidar@eldoy.com', :locals => {:name => 'Susana'})

module Susana
  class Mail

    def initialize
      # Collect existing emails
      @mails = YAML.load_file('./config/mail.yml').deep_symbolize_keys.tap{|r| r.delete(:defaults)}
    end

    # Try to send email
    def method_missing(name, *args, &block)
      # Lookup mail and deliver
      return deliver(*args) if (@mail = @mails[(@name = name)])

      super
    end

    # Deliver email
    def deliver(opt = {})

      # Don't deliver if we are in test env
      return false if App.env == 'test'

      # Symbolize keys
      opt = opt.deep_symbolize_keys

      # Set language
      @lang = I18n.locale || :en

      # Set wait to true to send without background process
      @wait = opt.delete(:wait) || false

      # Extract locals
      @locals = opt.delete(:locals) || {}

      # Extract layout
      @layout = opt.delete(:layout) || 'default'

      # Set up template path
      @path = "#{App.views}/mail/#{@name}/#{@name}.#{@lang}"

      # Set up options
      options = {
        :to => opt[:to] || @mail[:to],
        :from => opt[:from] || @mail[:from],
        :bcc => opt[:bcc] || @mail[:bcc],
        'h:Reply-To' => opt[:reply] || @mail[:reply],
        :subject => opt[:subject] || @mail[:subject],
        :text => opt[:text] || @mail[:text] || text,
        :html => opt[:html] || @mail[:html] || html
      }
      options.delete(:bcc) if options[:bcc].blank?

      # Mailgun url
      url = "#{App.settings.mailgun_api_url}/messages"

      # Deliver
      if(@wait)
        # Sending without background queue
        RestClient.post(url, options)
      else
        # Pass job to background processing
        MailJob.perform_async(url, options)
      end

    end

    private

    # Render html mail
    def html
      Tilt['erb'].new("#{App.views}/mail/layout/#{@layout}.#{@lang}.erb").render(self, @locals) {
        Tilt['erb'].new("#{@path}.erb").render(self, @locals)
      }
    end

    # Render text mail
    def text
      Tilt['erb'].new("#{@path}.txt").render(self, @locals)
    end

  end
end
