require 'test_helper'

class Jekyll::SearchTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Jekyll::Search::VERSION
  end

  def site
    @site ||= Jekyll::Site.new(Jekyll.configuration)
  end

  def test_generating_assets
    site.generate
    asset_count = Dir['assets/jekyll-search/*'].size
    assert_equal asset_count, site.static_files.size
    asset = site.static_files.first
  end

  def test_asset_tag
    tmpl = Liquid::Template.parse('{% jekyll_search_assets %}')
    tmpl.registers[:site] = site
    expected = <<-EXPECTED.chomp
<link rel="stylesheet" href="/assets/jekyll-search/jquery-ui.css">
<script src="/assets/jekyll-search/jquery-1.11.1.min.js"></script>
<script src="/assets/jekyll-search/jquery-ui.min.js"></script>
<script src="/assets/jekyll-search/jquery.select-to-autocomplete.js"></script>
    EXPECTED
    assert_equal expected, tmpl.render
  end
end
