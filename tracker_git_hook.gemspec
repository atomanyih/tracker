Gem::Specification.new do |s|
  s.name = 'tracker_git_hook'
  s.version = '1.0.0'

  s.summary = 'Simple command-line tool to tag stories from Pivotal Tracker in git commits'
  s.description = 'Simple command-line tool to tag stories from Pivotal Tracker in git commits. Uses git hooks.'

  s.authors = ['August Toman-Yih', 'Matt Hess']
  s.email = 'august.toman.yih@gmail.com'
  s.homepage = 'https://github.com/atomanyih/tracker'
  s.license = 'MIT'

  s.bindir = 'bin'
  s.executables << 'story'

  s.require_paths = ['lib']
  s.files = Dir['lib/**/*.rb']

  s.required_ruby_version = '~> 2.1'

  s.add_development_dependency 'rspec', '~> 3'
end
