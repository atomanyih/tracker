require 'tracker_git_hook/repo'

module TrackerGitHook
  describe Repo do
    describe '#set_story_id' do
      it 'writes the story id into the .git folder' do
        with_git_repo do |repo_path|
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
        with_git_repo do |repo_path|
          story_file_path = File.join(repo_path, '.git', 'tracker_story_id')
          File.open(story_file_path, 'w') do |f|
            f.write('54321')
          end

          repo = Repo.new(root_path: repo_path)
          expect(repo.get_story_id).to eq('54321')
        end
      end

      it 'returns nil if story file does no exist' do
        with_git_repo do |repo_path|
          repo = Repo.new(root_path: repo_path)
          expect(repo.get_story_id).to eq(nil)
        end
      end

      it 'returns nil if story file is empty' do
        with_git_repo do |repo_path|
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
          with_git_repo do |repo_path|
            repo = Repo.discover(path: repo_path)
            expect(repo.root_path).to eq(repo_path)
          end
        end
      end

      context 'in a subfolder of a git repo' do
        it 'finds the root' do
          with_git_repo do |repo_path|
            path = File.join(repo_path, 'folder')

            Dir.mkdir(path)

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

    describe '#install_hook' do
      it 'installs the given hook into the repo' do
        with_git_repo do |repo_path|
          repo = Repo.new(root_path: repo_path)
          hook = double(:hook, script: 'yo', filename: 'hook')

          repo.install_hook(hook)

          expected_hook_path = File.join(repo_path, '.git', 'hooks', 'hook')
          expect(File.exists?(expected_hook_path)).to eq(true)
          expect(File.read(expected_hook_path)).to eq('yo')
          expect(File.executable?(expected_hook_path)).to eq(true)
        end
      end
    end

    def with_git_repo(&blk)
      Dir.mktmpdir do |repo_path|
        `cd #{repo_path} && git init`

        blk.call repo_path
      end
    end
  end
end
