module HexagonalDomain
  module Mappers

    # Base class for mapping entity to a corresponding repository.
    #
    # == Define an entity to map
    #
    # Inside a mapper class declaration first define an entity class to map:
    #
    #     class YourMapper < HexagonalDomain::Mappers::Base
    #       
    #       maps YourEntity
    #       # ...
    #
    #   Usage of the mapper without an entity class defined raises an error:
    #
    #     class YourMapper < HexagonalDomain::Mappers::Base
    #     end
    #
    #     YourMapper.new # => <NotImplementedError "An entity klass to map by YourMapper hasn't been set.">
    #
    # == Define a repository to map to
    #
    # You should also define a repository to map to. You should do it outside of
    #    the mapper class (for example, do it within a Rails App initializer):
    #
    #     YourMapper.maps_to YourModel
    #
    # == Define operations
    #
    # Remember, that a mapper should only provide abstract interface for a
    # repository, which is not a part of your domain.
    #
    # Instead of concrete repository use <tt>YourMapper.repository</tt> method
    # to call the repository class inside the mapper.
    #
    #     class YourMapper
    #       
    #       def self.find(params)
    #         result = repository.where(params).first
    #
    #         # The result is a repository class object.
    #         # Convert it to the entity object:
    #         return entity.new result.attributes
    #       end
    #     end
    #
    # == Initialization
    #
    # Initialize your mapper for an entity
    #
    #     entity = YourEntity.new
    #     mapper = YourMapper.new entity
    #     mapper.save! # the method should be defined inside your mapper
    #
    # Initilization initializes a repository object and assigns it to 
    # a @repository attribute of the mapper instance.
    #
    # == Base mapper helpers
    #
    # === #entity
    #
    # An instance method to convert a repository instance back to the entity
    #
    #     mapper = YourMapper.new entity
    #     mapper.entity # => entity
    #
    #     mapper.entity(YourRepository.new) # => some entity
    #
    # Use it in your instance methods:
    #
    #     class YourMapper
    #       
    #       def save!
    #         @repository.save!
    #         entity # => without params returns a @repository object
    #       end
    #
    #       def destroy!
    #         @repository.destroy! and return entity
    #       end
    #     end
    #
    class Base

      class << self

        # Defines a repository to map entities to.
        def maps_to(klass)
          @repository = klass if !klass || klass.is_a?(Class)
        end

        # Returns an entity class to map.
        #
        # Raises <tt>NotImplementedError</tt> if a class hasn't been set by
        # a <tt>maps</tt> method.
        #
        def entity
          return @entity if @entity
          fail NotImplementedError,
            "An entity klass to map by #{ name } hasn't been set."
        end

        # Returns a repository class to map entities to.
        #
        # Raises <tt>NotImplementedError</tt>if a class hasn't been set by
        # a <tt>maps_to</tt> method.
        #
        def repository
          return @repository if @repository
          entity_name = entity.name
          fail NotImplementedError,
            "A repository for mapping #{ entity_name } by #{ name } hasn't been set."
        end

        # Converts repository items collection into a collection of
        # corresponding entities.
        def each_entity
          return to_enum(__callee__) unless block_given?
          each do |repository|
            yield entity(repository) if repository.is_a? self.repository
          end
        end

        private

          # Sets the class of entities to map to repository.
          def maps(klass)
            @entity = klass if !klass || klass.is_a?(Class)
          end
      end

      def initialize(entity)
        @repository = self.class.repository.new entity.attributes
      end

      # Converts a repository instance to a corresponding entity instance.
      # When called w/o an argument, returns an entity instance for 
      # the @repository instance.
      #
      def entity(repository = nil)
        self.class.entity.new (repository || @repository).attributes
      end
    end
  end
end
