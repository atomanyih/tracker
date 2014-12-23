module TrackerGitHook
  class StoryStatusChecker
    def initialize(repo:)
      @repo = repo
    end

    def check(message)
      if contains_completion_keyword?(message) &&
          contains_current_story_id?(message)

        @repo.clear_story_id
      end
    end

    private

    def contains_completion_keyword?(message)
      word = parse_message(message)[1]
      if word
        word.downcase.include? 'finish'
      end
    end

    def contains_current_story_id?(message)
      message_story_id = parse_message(message)[2]
      if message_story_id
        @repo.get_story_id == message_story_id
      end
    end

    def parse_message(message)
      regex = /\[\s*(\w*)\s*#(\d+)\s*\]/
      regex.match(message) || []
    end
  end
end
