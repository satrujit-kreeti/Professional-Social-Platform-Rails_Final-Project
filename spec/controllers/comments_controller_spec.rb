# rubocop:disable all

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) } 
  let(:comment_params) { attributes_for(:comment, content: 'Sample comment content.') }

  describe 'GET #new' do
    context 'when user is logged in' do
      before { sign_in(user) }

      it 'assigns @post' do
        get :new, params: { post_id: post.id }
        expect(assigns(:post)).to eq(post)
      end

      it 'assigns a new @comment' do
        get :new, params: { post_id: post.id }
        expect(assigns(:comment)).to be_a_new(Comment)
      end

      it 'renders the :new template' do
        get :new, params: { post_id: post.id }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'POST #create' do    
    context 'when user is logged in' do
      before { sign_in(user) }

      it 'creates a new comment' do
        expect do
          comment = create(:comment)
        end.to change(Comment, :count).by(1)
      end
    end
  end

  def sign_in(user)
    @request.session[:user_id] = user.id
  end
end
