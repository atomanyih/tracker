module TrackerGitHook
  class Installer
    def initialize(target_dir:, hook:)
      @target_dir = target_dir
      @hook = hook
    end

    def install
      hook_path = File.join(@target_dir, '.git', 'hooks', 'prepare-commit-msg')

      File.open(hook_path, 'w') do |f|
        f.write(@hook)
        f.chmod(0755)
      end
    end
  end
end
