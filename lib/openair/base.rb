require "typhoeus"
require "active_support/all"

class Openair::Base
	attr_accessor :api_key

	def initialize
		self.api_key = ENV["OPEN_AI_API_KEY"]
	end

	def base_url
		"https://api.openai.com/v1/"
	end

	def completion_defaults
		{
			"body" => {
				"model" => "text-davinci-003",
				"temperature" => 0.5,
				"max_tokens" => 100	
			},
			"url" => "completions",
			"method" => "POST",
			"headers" => {
				"Content-Type" => "application/json",
				"Authorization" => "Bearer #{self.api_key}"
			}
		}
	end

	def completion(args={})
		defaults = completion_defaults

		defaults = defaults.deep_merge(args)
		
		url = (base_url + defaults.delete("url"))

		response = Typhoeus::Request.new(url,method: defaults["method"],body: JSON.generate(defaults["body"]),headers: defaults["headers"]).run

		return response
	end
end
