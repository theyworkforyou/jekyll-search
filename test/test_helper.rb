$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'jekyll/search'

require 'minitest/autorun'

Jekyll.logger = Logger.new(StringIO.new)
