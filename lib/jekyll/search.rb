require 'jekyll/search/version'

require 'jekyll'

module Jekyll
  module Search
    class Generator < ::Jekyll::Generator
      def generate(site)
        assets.each do |file|
          site.static_files << Jekyll::StaticFile.new(
            site,
            root_dir,
            assets_dir,
            file
          )
        end
      end

      private

      def assets
        @assets ||= begin
          Dir.glob(File.join(root_dir, assets_dir, '*')).map do |asset|
            File.basename(asset)
          end
        end
      end

      def root_dir
        @root_dir ||= File.expand_path('../../..', __FILE__)
      end

      def assets_dir
        @assets_dir ||= File.join('assets', 'jekyll-search')
      end
    end
  end
end
