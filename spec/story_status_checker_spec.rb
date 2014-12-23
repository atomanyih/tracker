require 'tracker_git_hook/story_status_checker'

module TrackerGitHook
  shared_examples 'a completion tag' do
    def random_story_id
      (rand * 100000).floor
    end

    context 'story id matches current story' do
      it 'clears the story id' do
        expect(repo).to receive(:clear_story_id)
        StoryStatusChecker.new(repo: repo).check(message)
      end
    end

    context 'story id is not current story' do
      let(:message_story_id) { random_story_id }

      it 'does not clear the story id' do
        expect(repo).not_to receive(:clear_story_id)
        StoryStatusChecker.new(repo: repo).check(message)
      end
    end

    context 'multiple story ids' do
      let(:message) {"[#{keyword}  #5837 ##{message_story_id} #1564 #234583]"}

      it 'clears the story id' do
        expect(repo).to receive(:clear_story_id)
        StoryStatusChecker.new(repo: repo).check(message)
      end
    end
  end

  describe StoryStatusChecker do
    let(:message) { "[#{keyword}   ##{message_story_id}]" }

    let(:repo) { double(:repo, get_story_id: repo_story_id) }
    let(:repo_story_id) { '12345' }
    let(:message_story_id) { repo_story_id }

    context 'message is tagged as finished' do
      let(:keyword) { 'finiSheD ' }
      it_behaves_like 'a completion tag'
    end

    context 'message is tagged as fixed' do
      let(:keyword) { ' fixed' }
      it_behaves_like 'a completion tag'
    end

    context 'message is tagged as completed' do
      let(:keyword) { 'completed  ' }
      it_behaves_like 'a completion tag'
    end

    context 'message is not tagged as finished' do
      let(:keyword) { '' }

      it 'does not clear story id' do
        expect(repo).not_to receive(:clear_story_id)
        StoryStatusChecker.new(repo: repo).check(message)
      end
    end

    context 'message is not tagged' do
      let(:message) { 'whadup' }

      it 'does not clear story id' do
        expect(repo).not_to receive(:clear_story_id)
        StoryStatusChecker.new(repo: repo).check(message)
      end
    end
  end
end
