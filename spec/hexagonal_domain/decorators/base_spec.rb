require "spec_helper"

module HexagonalDomain
  module Decorators
    describe Base do

      before { class TestEntity; end }
      after  { Decorators.send :remove_const, :TestEntity }

      describe "::decorates (private method)" do

        it "defines the ::entity class for decoration" do
          class Base; decorates TestEntity; end
          Base.entity.should eq TestEntity
          class Base; decorates nil; end
        end
      end

      describe "::entity" do

        it "raises error unless entity class defined" do
          expect{ Base.entity }.to raise_error{ NotImplementedError }
        end
      end

      describe "::new" do

        before { class Base; decorates TestEntity; end }
        after  { class Base; decorates nil; end }

        let!(:entity) { TestEntity.new }
      
        it "raises error unless entity class defined" do
          class Base; decorates nil; end
          expect{ Base.new(entity) }.to raise_error{ NotImplementedError }
        end

        it "raises error if an argument has a wrong type" do
          expect{ Base.new 1 }.to raise_error{ ArgumentError }
        end

        it "raises error if an entity isn't set" do
          expect{ Base.new }.to raise_error
        end
      end

      describe "#entity" do

        before { class Base; decorates TestEntity; end }
        after  { class Base; decorates nil; end }

        let!(:entity)    { TestEntity.new }
        let!(:decorator) { Base.new entity }

        it "is readable" do
          decorator.entity.should eq entity
        end
      end

      describe "instance methods" do

        before { class Base; decorates TestEntity; end }
        after  { class Base; decorates nil; end }

        let!(:entity)    { TestEntity.new }
        let!(:decorator) { Base.new entity }

        before { entity.stub(:some_method) }

        it "delegated to the entity" do
          entity.should_receive(:some_method)
          decorator.some_method
        end
      end
    end
  end
end
