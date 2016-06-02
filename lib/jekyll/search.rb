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
        url = site.config['url']
        out = assets.map do |asset|
          path = File.join(assets_dir, asset)
          if asset.end_with?('css')
            %Q{<link rel="stylesheet" href="#{url}#{baseurl}/#{path}">}
          elsif asset.end_with?('js')
            %Q{<script src="#{url}#{baseurl}/#{path}"></script>}
          end
        end
        out.sort.join("\n")
      end
    end
    ::Liquid::Template.register_tag('jekyll_search_assets', AssetTag)

    class SearchOptionsTag < ::Liquid::Tag
      def render(context)
        context.registers[:site].config['search_options'] ||= generate_search_options(context)
      end

      private

      def generate_search_options(context)
        site = context.registers[:site]
        baseurl = site.config['baseurl']
        url = site.config['url']
        collections_to_search = site.config.fetch('collections_to_search', 'posts')
        options = Array(collections_to_search).map do |collection, field|
          site.collections[collection].docs.map do |doc|

            %Q(<option class="jekyll-search__option" value="#{[url, baseurl, doc.url].join}" data-alternative-spellings="#{AlternativeSpellings.for(collection.to_sym, doc).to_a.join(' ')}">#{doc.data['title']}</option>)
          end
        end
        [
          '<option class="jekyll-search__option">Search</option>',
          options
        ].flatten.compact.join("\n")
      end
    end
    ::Liquid::Template.register_tag('search_options', SearchOptionsTag)

    class SearchBoxTag < ::Liquid::Tag
      def render(context)
        ::Liquid::Template.parse('<div class="jekyll-search"><select class="jekyll-search__select" data-jekyll-search>{% search_options %}</select></div>').render(context)
      end
    end
    ::Liquid::Template.register_tag('jekyll_search_box', SearchBoxTag)

    class AlternativeSpellings
      def self.spellings
        @spellings ||= {}
      end

      def self.register(*collections, &block)
        collections.each do |collection|
          spellings[collection] = block
        end
      end

      def self.for(collection, document)
        block = spellings[collection]
        return [] if block.nil?
        block.call(document)
      end
    end
  end
end
