require 'spec_helper'

require "travis/lint"

describe ".travis.yml" do
  let(:travis_configuration) do
    path = Pathname.new("./.travis.yml").expand_path

    YAML.load_file(path.to_s)
  end

  it "should be a valid Travis-CI configuration file." do
    Travis::Lint::Linter.valid?(travis_configuration).should be_true
  end
end
