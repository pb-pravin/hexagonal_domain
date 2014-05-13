module HexagonalDomain
  module Mappers

    # Maps entity whose structure is equal to ActiveRecord table's one.
    class Simple < Base

      def self.where(params)
        @repository.where(params).each_entity
      end

      def self.all
        @repository.all.each_entity
      end

      def self.find(params)
        where(params).first
      end

      def save!
        @repository.save! and return entity
      end

      def destroy!
        @repository.destroy! and return entity
      end
    end
  end
end
