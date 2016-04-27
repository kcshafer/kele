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

    it "should retrieve messages" do
        body = File.read("spec/json/messages.json")
        stub_request(:get, "https://www.bloc.io/api/v1/message_threads").
            with(:body => "page=1", :headers => {'Authorization'=>'12345'}).
            to_return(:status => 200, :body => body, :headers => {})

        client = KeleClient.new('kc@test.com', 'test123')

        checkpoint = client.get_messages(1)
        expect(checkpoint).to_not be_nil
        expect(checkpoint).to be_a Hash
    end

    it "should send messages" do
        stub_request(:post, "https://www.bloc.io/api/v1/message").
            with(:body => "user_id=1&recipient_id=2&token=12345&subject=Test%20Message&body=Test%20Body", :headers => {'Authorization'=>'12345'}).
            to_return(:status => 200, :body => '{"success": true}', :headers => {})

        client = KeleClient.new('kc@test.com', 'test123')

        checkpoint = client.send_message(1, 2, "12345", "Test Message", "Test Body")
        expect(checkpoint).to_not be_nil
    end

    it "should submit checkpoints" do
        body = File.read("spec/json/checkpoint_submission.json")
        stub_request(:post, "https://www.bloc.io/api/v1/checkpoint_submissions").
            with(:body => "assignment_branch=branch&assignment_commit_link=https%3A%2Fgithub.com%2Fme%2Frepo%2Fcommit%2F5&checkpoint_id=1&comment=comment&enrollment_id=1",
              :headers => {'Authorization'=>'12345'}).
            to_return(:status => 200, :body => body, :headers => {})

        client = KeleClient.new('kc@test.com', 'test123')

        submission = client.create_submission("branch", "https:/github.com/me/repo/commit/5", 1, "comment", "1")
        expect(submission).to_not be_nil
        expect(submission).to be_a Hash
    end
end


