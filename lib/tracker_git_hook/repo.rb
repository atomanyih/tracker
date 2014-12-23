module TrackerGitHook
  class Repo
    def self.discover(path:)
      git_directory = File.join(path, '.git')

      if File.exists?(git_directory)
        Repo.new(root_path: path)
      else
        parent_path = File.dirname(path)
        if parent_path == path
          raise "Not in a git repo"
        end
        self.discover(path: parent_path)
      end
    end

    attr_reader :root_path

    def initialize(root_path:)
      @root_path = root_path
    end

    def set_story_id(story_id)
      File.open(story_file_path, 'w') do |f|
        f.write(story_id)
      end
    end

    def get_story_id
      if File.exists?(story_file_path)
        story_id = File.read(story_file_path)
        return story_id unless story_id.empty?
      end
    end

    def install_hook(hook)
      hook_path = File.join(root_path, '.git', 'hooks', hook.filename)

      File.open(hook_path, 'w') do |f|
        f.write(hook.script)
        f.chmod(0755)
      end
    end

    private

    def story_file_path
      File.join(root_path, '.git', 'tracker_story_id')
    end
  end
end
