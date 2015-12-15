require 'test_helper'

class Jekyll::SearchTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Jekyll::Search::VERSION
  end

  def test_generating_assets
    site = Jekyll::Site.new(Jekyll.configuration)
    site.generate
    asset_count = Dir['assets/jekyll-search/*'].size
    assert_equal asset_count, site.static_files.size
    asset = site.static_files.first
    require 'pry'; binding.pry
  end
end
