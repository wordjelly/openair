# frozen_string_literal: true

require "test_helper"

class TestOpenair < Minitest::Test

=begin
  def test_that_it_has_a_version_number
    refute_nil ::Openair::VERSION
  end
=end

  def test_base_completion
    openair = Openair::Base.new
    puts openair.numbered_completion_choices({"body" => {"prompt" => "Give me a list of the 10 best places to visit in Paris"}})
  end

=begin
  def test_it_gets_the_numbered_choices
    openair = Openair::Base.new
    puts (openair.numbered_completion_choices({"body" => {"prompt" => "dog is what kind of animal"}, "response" => openair.numbered_completion_dummy_response}))
  end
=end
end
