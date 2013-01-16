require 'spec_helper'

require_relative '../../plugin/cowsay_cinch_plugin.rb'

describe TurbotPlugins::Cowsay do
  subject(:plugin){ described_class.new(double.as_null_object) }
  let(:m) {double}

  context "#cowsay" do
    let(:reply_text) { "  ______________\n< Turbot Rocks!! >\n  --------------\n         \\   ^__^ \n          \\  (oo)\\_______\n             (__)\\       )\\/\\\n                 ||----w |\n                 ||     ||\n    " }
    it "should print out cowsay graphic." do
      m.should_receive(:reply).with(reply_text)
      VCR.use_cassette('cowsay'){ plugin.cowsay(m, 'Turbot Rocks!!')}
    end
  end

  context ".commands" do
    it "responds to .help with information about itself." do
      plugin.class.commands.matchers.should eql(".cowsay")
      plugin.class.commands.description.should eql("\x02Bovine Phrase\x02 = Awesome Cowsay Graphic")
    end
  end
end
