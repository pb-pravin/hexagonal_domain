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
    # Take into concideration that both <tt>repository_class_methods</tt> and 
    # <tt>repository_object_methods</tt> are private and should be used inside
    # the class declaration, whereas <tt>repository</tt> method is public and
    # is expected to be used outside of the class.
    #
    # The class also includes <tt>Virtus.model</tt> and 
    # <tt>ActiveModel::Validations</tt> to provide helpers:
    # * <tt>attribute</tt> (from virtus)
    # * <tt>validates</tt>.
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

      def self.included
        class_deprecated_message
      end

      def self.inherited
        class_deprecated_message
      end

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
          super unless self.class.send(:repository_methods).include?(name.to_s)
          repository.send name, *args, &block
        end

        def class_deprecated_message
          warn "[DEPRECATED] The HexagonalDomain::Entities::Base class is deprecated. Instead of using it as an active record, declare your entities as a simple structures and add corresponding mappers (see HexagonalDomain::Mappers::Base)."
        end
    end
  end
end
