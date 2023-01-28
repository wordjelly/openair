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

	## A DUMMY RESPONSE TO TEST THE NUMBERED CHOICES REGEXES.
	def numbered_completion_dummy_response(args={})
		sample = {
		  	"id" => "cmpl-6dc6mosWBlKaP6u4rTGUTI5UjgzzZ",
		  	"object" => "text_completion",
		  	"created" => 1674899300,
		  	"model" => "text-davinci-003",
		  	"choices" => [
		    	{
		      		"text" => "\n\n1. CAT w/ DOG\n2. ROCK & PIG\n3. MANGA\n4. PICKLE",
		      		"index" => 0,
		      		"logprobs" => nil,
		      		"finish_reason" => "stop"
		    	}
		  	],
			"usage" => {
			    "prompt_tokens" => 26,
			    "completion_tokens" => 31,
			    "total_tokens" => 57
			}
		}
		response = Typhoeus::Response.new
		response.options[:code] = 200
		response.options[:body] = JSON.generate(sample)
		return response
	end

	## sometimes we ask for a list of things.
	## gpt3 usually returns a bunch of items, delineated by a newline, and all starting with a digit.
	## so something like :
	## "\n\n1. dog\n2. cat\n3. rat\n4. pig
	## will return [dog,cat,rat,pig]
	## @return[Array] : strings containing the actual list content.
	def numbered_completion_choices(args={})
		arr = []
		completion_choices_text(args) do |text|
			text.split("\n").each do |k|
				arr << k.gsub(/^\s*\d+\./,'')	
			end
		end
		arr.select{|c| !c.strip.blank?}.map{|r| r.strip}
	end

	# yields : the text of the first choice in the completion
	# only yields if we got a 200 response.
	def completion_choices_text(args={},&block)
		response = completion(args)
		if response.code.to_s == "200"
			body = JSON.parse(response.body)
			if body["choices"]
				unless body["choices"].blank?
					unless body["choices"][0]["text"].blank?
						yield(body["choices"][0]["text"]) if block_given?
					end
				end
			end
		end
	end



	## you can pass in args[:response] to stub out a respons for testing.
	## you can see different dummy response methods
	def completion(args={})
		defaults = completion_defaults

		defaults = defaults.deep_merge(args)
		
		url = (base_url + defaults.delete("url"))

		return args["response"] if args["response"]

		response = Typhoeus::Request.new(url,method: defaults["method"],body: JSON.generate(defaults["body"]),headers: defaults["headers"]).run
		return response
		
	end
end
