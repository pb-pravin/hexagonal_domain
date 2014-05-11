require "spec_helper"

module HexagonalDomain
  module Entities
    describe Base do

      before { class BaseRepository < Struct.new(:entity); end }
      after do
        Base.repository = nil
        Base.send :repository_class_methods,  nil
        Base.send :repository_object_methods, nil
        Entities.send :remove_const, :BaseRepository
      end
      
      describe "::repository=" do

        it "устанавливает репозиторий для модели" do
          Base.repository = BaseRepository
          Base.send(:repository).should eq BaseRepository
        end
      end

      describe "::repository" do

        it "вызывает исключение, если репозиторий не установлен" do
          expect{ Base.send :repository }.to raise_error{ NotImplementedError }
        end
      end

      describe "::repository_class_methods" do

        before do
          Base.repository = BaseRepository
          Base.send :repository_class_methods, :find, :where
        end

        it "делегирует методы класса репозиторию" do
          [:find, :where].each do |method|
            BaseRepository.stub(method)
            BaseRepository.should_receive method
            Base.send method
          end
        end

        it "делегирует репозиторию только перечисленные методы класса" do
          expect{ Base.send :join }.to raise_error
        end
      end

      describe "::repository_object_methods" do

        before do
          Base.repository = BaseRepository
          Base.send :repository_object_methods, :save, :destroy
        end

        let!(:entity) { Base.new }

        it "делегирует методы объекта репозиторию" do
          %w(save destroy).each do |method|
            BaseRepository.any_instance.stub(method.to_sym).and_return{ self.entity }
            entity.send(method).should == entity
          end
        end

        it "делегирует репозиторию только перечисленные методы объекта" do
          expect{ entity.public_send :join }.to raise_error{ NoMethodError }
        end
      end
    end
  end
end
