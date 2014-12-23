require 'tracker_git_hook/story_status_checker'

module TrackerGitHook
  describe StoryStatusChecker do
    let(:message) { <<-TEXT }
[#{keyword}   ##{message_story_id}]
          TEXT

    let(:repo) { double(:repo, get_story_id: repo_story_id) }
    let(:repo_story_id) { '12345' }
    let(:message_story_id) { repo_story_id }

    context 'message is tagged as finished' do
      let(:keyword) { 'finiSheD' }

      context 'story id matches current story' do
        it 'clears the story id' do
          expect(repo).to receive(:clear_story_id)
          StoryStatusChecker.new(repo: repo).check(message)
        end
      end

      context 'story id is not current story' do
        let(:message_story_id) { '85858503' }

        it 'does not clear the story id' do
          expect(repo).not_to receive(:clear_story_id)
          StoryStatusChecker.new(repo: repo).check(message)
        end
      end
    end

    context 'message is not tagged as finished' do
      let(:keyword) { "" }

      it 'does not clear story id' do
        expect(repo).not_to receive(:clear_story_id)
        StoryStatusChecker.new(repo: repo).check(message)
      end
    end
  end
end
