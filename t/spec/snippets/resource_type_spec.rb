require 'spec_helper'

resource_type_dir = File.join(File.dirname(__FILE__), *%w[.. .. serverspec lib serverspec type])
snippets_resource_type_dir = File.join(File.dirname(__FILE__), *%w[.. .. .. snippets text-mode serverspec ResourceTypes])

RSpec.describe 'ResourceType' do
  Dir::open(resource_type_dir).each do |f|
    next if f == "." || f == ".." || f == "base.rb" || f == "docker_base.rb"
    resource_type_name = File.basename(f, ".rb")
    it "snippet '" + resource_type_name + "' should be exits" do
      expect(File).to exist(File.join(snippets_resource_type_dir, resource_type_name))
    end
  end

  Dir::open(snippets_resource_type_dir).each do |f|
    next if f == "." || f == ".."
    snippet_name = File.basename(f)
    resource_type_name = snippet_name + '.rb'
    it "snippet '" + resource_type_name + "' should not be exits" do
      expect(File).to exist(File.join(resource_type_dir, resource_type_name))
    end
  end
end
