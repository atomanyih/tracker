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
        elsif argument == 'whale'
          puts whale
        else
          puts usage
        end
      else
        puts repo.get_story_id
      end
    end

    private

    def usage
      'Usage: story [ <story_id> | finish ]'
    end

    def whale
      <<-'WHALE'

      __________...----..____..-'``-..___
    ,'.                                  ```--.._
   :                                             ``._
   |                           --                    ``.
   |                    ಠ          -.     -   -.        `.
   :                     __           --            .     \
    `._____________     (  `.   -.-      --  -   .   `     \
       `-----------------\   \_.--------..__..--.._ `. `.   :
                          `--'                     `-._ .   |
                                                       `.`  |
                                                         \` |
                                                          \ |
                                                          / \`.
                                                         /  _\-'
                                                        /_,'

      WHALE
    end

    def is_story_id?(string)
      !!/^\d+$/.match(string)
    end
  end
end
