module Roadmap
    def roadmap(roadmap_id)
        # GET /roadmaps/id

        resp = self.class.get("/roadmaps/#{roadmap_id}", :headers => { "Authorization": @token })

        return JSON.parse(resp.body)
    end

    def checkpoint(checkpoint_id)
         # GET /checkpoints/id

        resp = self.class.get("/checkpoints/#{checkpoint_id}", :headers => { "Authorization": @token })

        return JSON.parse(resp.body)
    end
end