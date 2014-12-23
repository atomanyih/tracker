require 'tracker_git_hook/installer'
require 'tmpdir'

module TrackerGitHook
  describe Installer do
    it 'installs a hook for adding the story id' do
      repo = double(:repo)

      expect(repo).to receive(:install_hook).
        with(an_instance_of(AddStoryIdHook))

      Installer.new(repo: repo).install
    end
  end
end
