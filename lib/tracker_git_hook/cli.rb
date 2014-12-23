module TrackerGitHook
  class Cli
    def initialize(repo:)
      @repo = repo
    end

    attr_reader :repo

    def process_arguments(*args)
      argument = args[0]

      if argument
        if is_story_id?(argument)
          repo.set_story_id(argument)
        elsif argument == 'finish'
          repo.clear_story_id
        else
          puts usage
        end
      else
        puts repo.get_story_id
      end
    end

    def usage
      'Usage: story [ <story_id> | finish ]'
    end

    def is_story_id?(string)
      !!/^\d+$/.match(string)
    end
  end
end
