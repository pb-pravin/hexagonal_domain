require "spec_helper"

module HexagonalDomain
  module UseCases
    describe Base do
      
      describe "#params" do

        it "stringifies keys" do
          use_case = Base.new name: "some name"
          use_case.params.should == { "name" => "some name" }
        end
      end

      describe "#run" do

        let!(:use_case) { Base.new }

        it "is defined" do
          use_case.should respond_to(:run).with(0).arguments
        end

        it "calls for implementation" do
          expect{ use_case.run }.to raise_error{ NotImplementedError }
        end
      end

      describe "#subscribe" do

        let!(:use_case) { Base.new }

        it "is defined" do
          use_case.should respond_to(:subscribe)
        end
      end

      describe "#publish" do

        let!(:use_case) { Base.new }

        it "calls the subscribed listener's method" do
          listener = double(success: true)
          use_case.subscribe(listener)
          listener.should_receive :success
          use_case.send :publish, :success
        end
      end
    end
  end
end
