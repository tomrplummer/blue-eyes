require_relative '../../lib/blue_eyes'

RSpec.describe BlueEyes::Routes do
  include BlueEyes::Routes

  describe '#get_resources' do
    it 'generates the correct route for a resource without options' do
      expect(get_resources('posts')).to eq('/posts')
    end

    it 'generates the correct route for a resource with belongs_to option' do
      expect(get_resources('comments', belongs_to: 'post')).to eq('/posts/:post_id/comments')
    end

    it 'generates the correct route for a resource with as option' do
      expect(get_resources('posts', as: 'articles')).to eq('/articles')
    end
  end

  describe '#get_resource' do
    it 'generates the correct route for a single resource' do
      expect(get_resource('post')).to eq('/posts/:id')
    end
  end

  describe '#put_resource' do
    it 'generates the correct route for updating a resource' do
      expect(put_resource('post')).to eq('/posts/:id')
    end
  end

  describe '#post_resource' do
    it 'generates the correct route for creating a resource' do
      expect(post_resource('posts')).to eq('/posts')
    end

    it 'generates the correct route for a nested resource' do
      expect(post_resource('comments', belongs_to: 'post')).to eq('/posts/:post_id/comments')
    end
  end

  describe '#new_resource' do
    it 'generates the correct route for a new resource' do
      expect(new_resource('post')).to eq('/posts/new')
    end

    it 'generates the correct route for a new nested resource' do
      expect(new_resource('comment', belongs_to: 'post')).to eq('/posts/:post_id/comments/new')
    end
  end

  describe '#edit_resource' do
    it 'generates the correct route for editing a resource' do
      expect(edit_resource('post')).to eq('/posts/:id/edit')
    end
  end

  describe '#delete_resource' do
    it 'generates the correct route for deleting a resource' do
      expect(delete_resource('post')).to eq('/posts/:id')
    end
  end

  describe '#handle_options' do
    it 'handles the belongs_to option correctly' do
      resource_name, belongs_to, stub = handle_options('comments', belongs_to: 'post')
      expect(resource_name).to eq('comments')
      expect(belongs_to).to eq('posts')
      expect(stub).to eq('post')
    end

    it 'handles the as option correctly' do
      resource_name, = handle_options('posts', as: 'articles')
      expect(resource_name).to eq('articles')
    end
  end

  describe '#base_route' do
    it 'returns the correct base route for nested resources' do
      expect(base_route('posts', 'post')).to eq('/posts/:post_id')
    end

    it 'returns an empty string for non-nested resources' do
      expect(base_route(nil, nil)).to eq('')
    end
  end
end
