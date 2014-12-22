require 'tracker_git_hook/repo'

module TrackerGitHook
  describe Repo do
    describe '#set_story_id' do
      it 'writes the story id into the .git folder' do
        Dir.mktmpdir do |repo_path|
          `cd #{repo_path} && git init`
          repo = Repo.new(root_path: repo_path)
          repo.set_story_id('12345')

          story_file_path = File.join(repo_path, '.git', 'tracker_story_id')
          expect(File.exists?(story_file_path)).to eq(true)
          expect(File.read(story_file_path)).to eq('12345')
        end
      end
    end

    describe '#get_story_id' do
      it 'gets the story id from file' do
        Dir.mktmpdir do |repo_path|
          `cd #{repo_path} && git init`
          story_file_path = File.join(repo_path, '.git', 'tracker_story_id')
          File.open(story_file_path, 'w') do |f|
            f.write('54321')
          end

          repo = Repo.new(root_path: repo_path)
          expect(repo.get_story_id).to eq('54321')
        end
      end

      it 'returns nil if story file does no exist' do
        Dir.mktmpdir do |repo_path|
          `cd #{repo_path} && git init`
          repo = Repo.new(root_path: repo_path)
          expect(repo.get_story_id).to eq(nil)
        end
      end

      it 'returns nil if story file is empty' do
        Dir.mktmpdir do |repo_path|
          `cd #{repo_path} && git init`
          story_file_path = File.join(repo_path, '.git', 'tracker_story_id')

          File.open(story_file_path, 'w')

          repo = Repo.new(root_path: repo_path)
          expect(repo.get_story_id).to eq(nil)
        end
      end
    end

    describe '.discover' do
      context 'in the root of a git repo' do
        it 'creates a repo with the current directory' do
          Dir.mktmpdir do |repo_path|
            `cd #{repo_path} && git init`

            repo = Repo.discover(path: repo_path)
            expect(repo.root_path).to eq(repo_path)
          end
        end
      end

      context 'in a subfolder of a git repo' do
        it 'finds the root' do
          Dir.mktmpdir do |repo_path|
            `cd #{repo_path} && git init && mkdir folder`

            path = File.join(repo_path, 'folder')

            repo = Repo.discover(path: path)
            expect(repo.root_path).to eq(repo_path)
          end
        end
      end

      context 'outside of a git repo' do
        it 'freaks out' do
          Dir.mktmpdir do |path|
            expect {
              Repo.discover(path: path)
            }.to raise_error("Not in a git repo")
          end
        end
      end
    end
  end
end
