require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:valid_attributes) {
    { title: "Test Post", description: "This is a test description" }
  }

  let(:invalid_attributes) {
    { title: "", description: "" }
  }

  describe "GET /index" do
    it "renders a successful response" do
      Post.create! valid_attributes
      get posts_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      post = Post.create! valid_attributes
      get post_url(post)
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      post = Post.create! valid_attributes
      get edit_post_url(post)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    it "create a new Post" do
      expect {
        post posts_url, params: { post: valid_attributes }
      }.to change(Post, :count).by(1)
    end

    it "redirects to the cretead post" do
      post posts_url, params: { post: valid_attributes }
      expect(response).to redirect_to(post_url(Post.last))
    end
  end

  context "with invalid parameters" do
    it "does not create a new Post" do
      expect {
        post posts_url, params: { post: invalid_attributes }
      }.to change(Post, :count).by(0)
    end

    it "renders a response with 422 status (i.e., unprocessable entity)" do
      post posts_url, params: { post: invalid_attributes }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /update" do
    let(:new_attributes) {
      { title: "Updated Title", description: "Updated description" }
    }

    context "with valid parameters" do
      it "updates the requested post" do
        post = Post.create! valid_attributes
        patch post_url(post), params: { post: new_attributes }
        post.reload
        expect(post.title).to eq("Updated Title")
        expect(post.description).to eq("Updated description")
      end

      it "redirects to the post" do
        post = Post.create! valid_attributes
        patch post_url(post), params: { post: new_attributes }
        expect(response).to redirect_to(post_url(post))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e., unprocessable entity)" do
        post = Post.create! valid_attributes
        patch post_url(post), params: { post: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested post" do
      post = Post.create! valid_attributes
      expect {
        delete post_url(post)
      }.to change(Post, :count).by(-1)
    end

    it "redirects to the posts list" do
      post = Post.create! valid_attributes
      delete post_url(post)
      expect(response).to redirect_to(posts_url)
    end
  end
end
