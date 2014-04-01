require 'bundler'

Bundler.require

require 'yaml/store'
require './app/libs/idea'
require './app/libs/idea_store'
require './app/libs/tagManager'
require './app/libs/groupManager'
require './app/ideaBoxApp'

run IdeaBoxApp
