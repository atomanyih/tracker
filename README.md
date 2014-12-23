#Tracker Git Hook

Simple command-line tool for Pivotal Tracker story integration with git.

## All it does
is put the story id into your commit message like this:

```
  This is a commit message
  
  [#12345]
```

If there's already a tag in there it won't overwrite it.

If you put 'finished' it will stop tracking the story

That's it.

## Usage
`$ story <story_id>` will set your current story id

`$ story` will print the current story id

`$ story finish` will unset the current story id
