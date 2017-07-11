# Use the sitemap to let search engines know about and crawl your site
# Add it to Google and Bing web master tools

module Susana
  class Sitemap

    # Setup
    def initialize
      SitemapGenerator::Sitemap.default_host = App.settings.url
      SitemapGenerator::Sitemap.include_root = false
      SitemapGenerator::Sitemap.public_path = 'app/views/root'
      SitemapGenerator::Sitemap.compress = false
    end

    # Ping search engines about changes
    def ping
      SitemapGenerator::Sitemap.ping_search_engines
    end

    # Write sitemap.xml found at http://yourdomain.com/sitemap.xml
    def write
      SitemapGenerator::Sitemap.create do

        # Add your sitemap entries here
        add('/', :changefreq => 'daily', :priority => 0.9)

        # Using multiple languages
        # add('/', :alternate => {:href => '/no', :lang => 'no'})
        # add('/', :alternate => [{:href => '/no', :lang => 'no'}, {:href => '/es', :lang => 'es'}])

        # More options: https://github.com/kjvarga/sitemap_generator
      end
    end

  end
end
