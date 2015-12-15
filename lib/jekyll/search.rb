require 'jekyll/search/version'

require 'jekyll'

module Jekyll
  module Search
    module Assets
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

    class Generator < ::Jekyll::Generator
      include Assets

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
    end

    class AssetTag < ::Liquid::Tag
      include Assets

      def render(context)
        site = context.registers[:site]
        baseurl = site.config['baseurl']
        out = assets.map do |asset|
          path = File.join(assets_dir, asset)
          if asset.end_with?('css')
            %Q{<link rel="stylesheet" href="#{baseurl}/#{path}">}
          elsif asset.end_with?('js')
            %Q{<script src="#{baseurl}/#{path}"></script>}
          end
        end
        out.sort.join("\n")
      end
    end
    Liquid::Template.register_tag('jekyll_search_assets', AssetTag)
  end
end
