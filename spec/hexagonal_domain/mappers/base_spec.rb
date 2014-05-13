require "spec_helper"

module HexagonalDomain
  module Mappers
    describe Base do
      
      before do
        class TestEntity < OpenStruct;     def attributes; to_h; end; end
        class TestRepository < OpenStruct; def attributes; to_h; end; end
      end

      after do
        Mappers.send :remove_const, :TestRepository
        Mappers.send :remove_const, :TestEntity
      end

      describe "::maps (private method)" do

        it "defines the entity class to map to repository" do
          class Base; maps TestEntity; end
          Base.entity.should eq TestEntity
          class Base; maps nil; end
        end
      end

      describe "::entity" do

        it "raises an error unless an entity class defined" do
          expect{ Base.entity }.to raise_error{ NotImplementedError }
        end
      end

      describe "::maps_to" do

        it "defines the repository class to map entity to" do
          Base.maps_to TestRepository
          Base.repository.should eq TestRepository
        end
      end

      describe "::repository" do

        it "raises an error unless an entity class defined" do
          Base.maps_to nil
          expect{ Base.repository }.to raise_error{ NotImplementedError }
        end
      end

      describe "::new" do

        before { class Base; maps TestEntity; maps_to TestRepository; end }
        after  { class Base; maps nil; maps_to nil; end }

        let!(:entity) { TestEntity.new name: "Andrew" }

        it "initializes a repository private attribute" do
          class Base; attr_reader :repository; end
          mapper = Base.new entity
          mapper.repository.should be_kind_of TestRepository
          mapper.repository.name.should eq "Andrew"
        end

        it "raises an error if an argument has wrong type" do
        end

        it "raises an error if no argument given" do
        end
      end

      describe "#entity" do

        before { class Base; maps TestEntity; maps_to TestRepository; end }
        after  { class Base; maps nil; maps_to nil; end }

        let!(:entity) { TestEntity.new name: "Leo" }
        let!(:mapper) { Base.new entity }

        it "returns an entity from a repository private attribute" do
          mapper.entity.should eq entity
        end

        it "returns an entity for given repository" do
          repository = TestRepository.new name: "Andy"
          new_entity = mapper.entity(repository)
          new_entity.should be_kind_of TestEntity
          new_entity.name.should eq "Andy"
        end
      end
    end
  end
end
