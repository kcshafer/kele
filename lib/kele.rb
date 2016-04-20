require 'httparty'

require 'json'

require "kele/version"

class KeleClient
    include HTTParty
    base_uri 'https://www.bloc.io/api/v1'

    attr_reader :token, :log
    attr_accessor :logging

    def initialize(username, password, logging=true)
        @log = []
        act = 'AUTHENTICATION'
        msg = ''
        @logging = logging

        options = { :body => {:email => username, :password => password} }
        resp = self.class.post('/sessions', options)
        
        if resp.code == 200 then
            resp_body = JSON.parse(resp.body)
            @token = resp_body['auth_token']
            msg = "Success: Authenticated as #{username} successfully!"
        else
            msg = "Failed: Unable to authenticate as #{username}, check username/password and try again."
        end 

        log_message(act, msg)
    end

    private

    def log_message(act, msg)
        if @logging then
            log << "#{act} at #{Time.now} - #{msg}" 
        end
    end
end
