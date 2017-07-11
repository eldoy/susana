# Locale setup
require 'i18n/backend/fallbacks'
I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
I18n.load_path = Dir[File.join(App.root, 'config', 'locales', '*.yml')]
I18n.backend.load_translations
I18n.default_locale = :en
