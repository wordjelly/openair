# frozen_string_literal: true

require "test_helper"

class TestOpenair < Minitest::Test

=begin
  def test_that_it_has_a_version_number
    refute_nil ::Openair::VERSION
  end
=end

  def test_it_does_something_useful
    openair = Openair::Base.new
    openair.completion({"body" => {"prompt" => "dog is what kind of animal"}})
  end
end
