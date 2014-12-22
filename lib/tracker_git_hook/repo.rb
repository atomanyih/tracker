module TrackerGitHook
  class Repo
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

    private

    def story_file_path
      File.join(@root_path, '.git', 'tracker_story_id')
    end
  end
end
