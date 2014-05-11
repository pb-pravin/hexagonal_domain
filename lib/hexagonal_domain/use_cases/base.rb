require "wisper"

module HexagonalDomain
  module UseCases

    # Base class for domain model use cases.
    #
    # Inherit your use case from the class and define a #run method:
    #
    #     class YourCase < HexagonalDomain::UseCases::Base
    #       def run
    #         begin
    #           # define actions
    #         rescue
    #           publish :error
    #         else
    #           publish :success
    #         end
    #       end
    #     end
    #
    class Base
      include Wisper::Publisher

      attr_reader :params

      def initialize(params = {})
        @params = params.dup.stringify_keys!
      end

      def run
        fail NotImplementedError,
          "The #{ self.class.name }#run method not implemented yet."
      end
    end
  end
end
