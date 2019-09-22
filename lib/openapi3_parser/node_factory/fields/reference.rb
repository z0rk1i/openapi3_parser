# frozen_string_literal: true

require "openapi3_parser/node_factory/field"

module Openapi3Parser
  module NodeFactory
    module Fields
      class Reference < NodeFactory::Field
        def initialize(context, factory)
          super(context, input_type: String, validate: :validate)
          @factory = factory
          @reference = context.input
          @resolved_reference = create_resolved_reference
        end

        def resolved_input
          return unless resolved_reference

          resolved_reference.resolved_input
        end

        private

        attr_reader :reference, :factory, :resolved_reference

        def build_node(_data, node_context)
          reference_context = Node::Context.resolved_reference(
            node_context,
            resolved_reference.factory.context
          )

          resolved_reference&.node(reference_context)
        end

        def validate(validatable)
          if !reference_validator.valid?
            validatable.add_errors(reference_validator.errors)
          else
            validatable.add_errors(resolved_reference&.errors)
          end
        end

        def reference_validator
          @reference_validator ||= Validators::Reference.new(reference)
        end

        def create_resolved_reference
          return unless reference_validator.valid?
          context.resolve_reference(reference, factory)
        end
      end
    end
  end
end
