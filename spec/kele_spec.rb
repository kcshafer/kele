require 'spec_helper'

describe Kele do
    before do
        session_body = '{"auth_token": "12345"}'
        stub_request(:post, "https://www.bloc.io/api/v1/sessions").
            with(:body => "email=kc%40test.com&password=test123").
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
        body = File.read('spec/json/get_me.json')
        stub_request(:get, "https://www.bloc.io/api/v1/users/me").
            with(:headers => {'Authorization'=>'12345'}).
            to_return(:status => 200, :body => body, :headers => {})


        client = KeleClient.new('kc@test.com', 'test123')

        user_info = client.get_me
        expect(user_info).to_not be_nil
        expect(user_info).to be_a Hash
    end

    it "should retrieve mentor availability" do
        body = File.read('spec/json/mentor_availability.json')
        stub_request(:get, "https://www.bloc.io/api/v1/mentors/1/student_availability").
            with(:headers => {'Authorization'=>'12345'}).
            to_return(:status => 200, :body => body, :headers => {})


        client = KeleClient.new('kc@test.com', 'test123')

        mentor_availability = client.get_mentor_availability(1)
        expect(mentor_availability).to_not be_nil
        expect(mentor_availability).to be_a Array
    end

    it "should retrieve roadmap" do
        body = File.read("spec/json/roadmap.json")
        stub_request(:get, "https://www.bloc.io/api/v1/roadmaps/31").
            with(:headers => {'Authorization'=>'12345'}).
            to_return(:status => 200, :body => body, :headers => {})

        client = KeleClient.new('kc@test.com', 'test123')

        roadmap = client.get_roadmap(31)
        expect(roadmap).to_not be_nil
        expect(roadmap).to be_a Hash
    end

    it "should retrieve checkpoint" do
        body = File.read("spec/json/checkpoint.json")
        stub_request(:get, "https://www.bloc.io/api/v1/checkpoints/1606").
            with(:headers => {'Authorization'=>'12345'}).
            to_return(:status => 200, :body => body, :headers => {})

        client = KeleClient.new('kc@test.com', 'test123')

        checkpoint = client.get_checkpoint(1606)
        expect(checkpoint).to_not be_nil
        expect(checkpoint).to be_a Hash
    end
end


