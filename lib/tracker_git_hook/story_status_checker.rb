module TrackerGitHook
  class StoryStatusChecker
    def initialize(repo:)
      @repo = repo
    end

    def check(message)
      if contains_completion_keyword?(message) && contains_current_story_id?(message)
        repo.clear_story_id
      end
    end

    private

    attr_reader :repo

    def contains_completion_keyword?(message)
      word = parse_message(message)[1]
      return false unless word

      completion_keywords.any? do |keyword|
        word.downcase.include? keyword
      end
    end

    def completion_keywords
      %w(finish fix complete)
    end

    def contains_current_story_id?(message)
      message_story_ids = parse_message(message)[2]

      message_story_ids.include? repo.current_story_id
    end

    def parse_message(message)
      regex = /\[\s*(\w*)\s*((#\d+\s*)+)\]/
      regex.match(message) || []
    end
  end
end
