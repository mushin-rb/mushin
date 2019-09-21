require 'httparty'

module Mushin
  module Service
    refine Class do
      # Default Provider 
      provider = "https://api.hackspree.com" 
      #response = HTTParty.get('http://api.stackexchange.com/2.2/questions?site=stackoverflow')

      # https://api.hackspree.com as a Domain-as-a-Service provider
      #TODO ability to configure your DaaS providers via Mushin::Service in the DSF or the Application.
      #TODO Auth via security token 

      # Usage: Domain Frameworks may `use Mushin::Service::GameOn, params: {}, opts: {}`
      #
    end
  end
end
