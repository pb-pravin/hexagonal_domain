module HexagonalDomain
  module Decorators

    # Basic object for decorators.
    #
    # Declares private class method <tt>decorates</tt> to define decorated
    # entity class:
    #
    #     class MyDecorator < Base
    #       decorates MyEntity
    #       
    #       # add some methods
    #     end
    #
    # Initializing new instance before entity definition raises an error:
    #
    #     class MyDecorator < Base
    #     end
    #
    #     MyDecorator.new
    #     # => <NotImplementedError "A class to be decorated by MyDecorator hasn't been defined yet.">
    #
    # Decorated object initializes with an entity to be decorated:
    #
    #     entity = MyEntity.new
    #     decorator = MyDecorator.new entity
    #
    # The entity is available for reading:
    #
    #     decorator.entity
    #
    # An entity should have a type, defined by <tt>decorator</tt> method. 
    # In case of wrong type an error is raised:
    #
    #     decorator.new 1
    #     # => <ArgumentError "MyDecorator decorates objects of MyEntity class. Instead an object of Integer class has been given.">
    #
    # Instance methods are delegated to the entity:
    #
    #     entity.name = "Some name"
    #     decorator = MyDecorator.new entity
    #     decorator.name # => entity.name     
    #
    class Base

      class << self

        def entity
          return @entity if @entity
          fail NotImplementedError,
            "A class to be decorated by #{ self.class.name } hasn't been defined yet."
        end
        
        private

          def decorates(klass)
            @entity = klass
          end
      end

      attr_reader :entity

      def initialize(entity)
        klass, entity_klass = self.class.entity.name, entity.class.name
        if klass == entity_klass
          @entity = entity
        else
          fail ArgumentError,
            "#{ self.class.name } decorates objects of #{ klass }. Instead an object of #{ entity_klass } class has been given."
        end
      end

      private

        def method_missing(name, *args, &block)
          entity.public_send name, *args, &block
        end
    end
  end
end
