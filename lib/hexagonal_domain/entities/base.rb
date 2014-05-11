require "active_model"
require "virtus"

module HexagonalDomain
  module Entities

    # Base class for domain entities.
    #
    # Entities are expected to describe your domain entities in isolation
    # from the repository (database, file, cachestore etc.) to store them.
    #
    # Entities responds for data validation only. They provide
    # interface between use cases and repository - by delegation all the
    # storage methods (find, save, destroy etc.) to some repository.
    #
    # Any entity class should be connected to its repository class with
    # those methods defined.
    #
    # == Usage
    #
    # Inherit your class from the base and declare methods to be delegated
    # to repository
    #
    #     class MyEntity < HexagonalDomain::Entities::Base
    #
    #       # Declares the only methods delegated to a repository
    #       repository_class_methods  :find, :where
    #       repository_object_methods :save, :destroy
    #
    #       # entity-specific attributes and validations
    #     end
    #
    # and then define a corresponding repository class:
    #
    #     MyEntity.repository = MyEntityRepository
    #
    # Take into concideration that both `repository_class_methods` and 
    # `repository_object_methods` are private and should be used inside
    # the class declaration, whereas `repository` method is public and
    # is expected to be used outside of the class.
    #
    # The class also includes `Virtus.model` and `ActiveModel::Validations`
    # to provide helpers `attribute` (from virtus) and `validates`.
    #
    #     require "hexagonal_domain"
    #
    #     class Doc < HexagonalDomain::Entities::Base
    #
    #       repository_class_methods  :find, :where
    #       repository_object_methods :save, :destroy
    #
    #       attribute :number, String
    #       attribute :date,   Date
    #
    #       validates :number, :date, presence: true
    #     end
    #
    class Base
      include Virtus.model
      include ActiveModel::Validations

      class << self

        # Sets a repository
        attr_writer :repository

        private

          # Sets a list of methods to be delegated to repository class
          def repository_class_methods(*methods)
            @repository_scopes = methods.map{ |name| name.to_s }
          end

          # Sets a list of methods to be delegated to repository object
          def repository_object_methods(*methods)
            @repository_methods = methods.map{ |name| name.to_s }
          end

        private

          # Returns a repository for the class.
          # Raises if a repository hasn't been set.
          def repository
            return @repository if @repository
            fail NotImplementedError,
              "Repository for #{ self.class.name } hasn't been set yet."
          end

          # Returns a list of methods delegated to repository class
          def repository_scopes
            @repository_scopes ||= []
          end

          # Returns a list of methods delegated to repository object
          def repository_methods
            @repository_methods ||= []
          end

          # Delegates methods to the entity class repository.
          def method_missing(name, *args, &block)
            super unless repository_scopes.include? name.to_s
            repository.public_send name, *args, &block
          end
      end

      private

        # Returns a repository (data object) for the entity object.
        # Raises if a repository hasn't been set for the entity class.
        def repository
          self.class.send(:repository).new(self)
        end

        # Delegates methods to the entity object's repository object.
        def method_missing(name, *args, &block)
          super unless self.class.repository_methods.include?(name.to_s)
          repository.public_send name, *args, &block
        end
    end
  end
end
