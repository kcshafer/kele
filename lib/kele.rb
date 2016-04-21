require 'httparty'

require 'json'

require "kele/version"
require "roadmap"

class KeleClient
    include HTTParty
    include Roadmap
    base_uri 'https://www.bloc.io/api/v1'

    attr_reader :token

    def initialize(username, password, logging=true)
        options = { :body => {:email => username, :password => password} }
        resp = self.class.post('/sessions', options)
        resp_body = JSON.parse(resp.body)
        @token = resp_body['auth_token']

        if resp.code == 200 then
            puts "Success: Authenticated #{username}!"
        else
            puts "Failed: Unable to authenticate #{username}."
        end
    end

    def get_me
        # GET /users/me

        resp = self.class.get('/users/me', :headers => { "Authorization": @token })

        return JSON.parse(resp.body)
    end

    def get_mentor_availability(mentor_id)
        # GET /mentors/id/student_availability

        resp = self.class.get("/mentors/#{mentor_id}/student_availability", :headers => { "Authorization": @token })

        return JSON.parse(resp.body)
    end

    def get_roadmap(roadmap_id)
        roadmap(roadmap_id)
    end

    def get_checkpoint(checkpoint_id)
        checkpoint(checkpoint_id)
    end
end
