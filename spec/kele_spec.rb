require 'spec_helper'

describe Kele do
    before do
        session_body = '{"auth_token": "12345"}'
        stub_request(:post, "https://www.bloc.io/api/v1/sessions").
            with(:body => "email=kc%40test.com&password=test123", :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
            to_return(:status => 200, :body => session_body, :headers => {})
    end

    it 'has a version number' do
        expect(Kele::VERSION).not_to be nil
    end

    it "should handle authentication success" do
        client = KeleClient.new('kc@test.com', 'test123')

        expect(client.token).to eq('12345')
    end

    it "should handle authentication failure" do
        session_body = '{"message": "Email or password was incorrect"}'
        stub_request(:post, "https://www.bloc.io/api/v1/sessions").
            with(:body => "email=kc%40test.com&password=test123", :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
            to_return(:status => 401, :body => session_body, :headers => {})

        client = KeleClient.new('kc@test.com', 'test123')

        expect(client.token).to be_nil
    end

    it "should retrieve user information" do
        body = File.read('lib/json/get_me.json')
        stub_request(:get, "https://www.bloc.io/api/v1/users/me").
            with(:headers => {'Authorization'=>'12345'}).
            to_return(:status => 200, :body => body, :headers => {})


        client = KeleClient.new('kc@test.com', 'test123')

        user_info = client.get_me
        expect(user_info).to_not be_nil
    end
end


