require 'spec_helper'
require 'pp'

matcher_dir = File.join(File.dirname(__FILE__), *%w[.. .. serverspec lib serverspec matcher])
dict_file = File.join(File.dirname(__FILE__), *%w[.. .. .. dict serverspec])

dict_words = File.open(dict_file).each_line.map(&:chomp)

RSpec.describe 'Matcher' do
  Dir::open(matcher_dir).each {|f|
    next if f == "." || f == ".."
    matcher_name = File.basename(f, ".rb")
    it matcher_name + " word include" do
      expect(dict_words).to include(matcher_name)
    end
  }
end
