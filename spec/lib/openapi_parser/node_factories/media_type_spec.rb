# frozen_string_literal: true

require "openapi_parser/node_factories/media_type"
require "openapi_parser/nodes/media_type"

require "support/node_object_factory"
require "support/helpers/context"

RSpec.describe OpenapiParser::NodeFactories::MediaType do
  include Helpers::Context

  it_behaves_like "node object factory", OpenapiParser::Nodes::MediaType do
    let(:input) do
      {
        "schema" => {
          "$ref" => "#/components/schemas/Pet"
        },
        "examples" => {
          "cat"  => {
            "summary" => "An example of a cat",
            "value" => {
              "name" => "Fluffy",
              "petType" => "Cat",
              "color" => "White",
              "gender" => "male",
              "breed" => "Persian"
            }
          },
          "dog" => {
            "summary" => "An example of a dog with a cat's name",
            "value"  =>  {
              "name" => "Puma",
              "petType" => "Dog",
              "color" => "Black",
              "gender" => "Female",
              "breed" => "Mixed"
            }
          }
        }
      }
    end

    let(:document_input) do
      {
        "components" => {
          "schemas" => {
            "Pet" => {
              "type" => "object",
              "discriminator" => { "propertyName" => "petType" },
              "properties" => {
                "name" => { "type" => "string" },
                "petType" => { "type" => "string" }
              },
              "required" => %w[name petType]
            }
          }
        }
      }
    end

    let(:context) { create_context(input, document_input: document_input) }
  end
end