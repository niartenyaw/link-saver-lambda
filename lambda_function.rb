require_relative 'lib/file_updater'
require_relative 'lib/git_handler'
require_relative 'lib/slack_channel_history'

CHANNELS = [
  'ethics'
].freeze

REPO_NAME = 'saved-links'.freeze

def lambda_handler(event:, context:)
  git_handler = GitHandler.new(repo_location: REPO_NAME)

  git_handler.clone

  histories = SlackChannelHistory.new(channels: CHANNELS).call

  FileUpdater.new(
    channels: CHANNELS,
    histories: histories,
    repo_location: REPO_NAME
  ).call

  git_handler.save

  { statusCode: 200 }
end

if $PROGRAM_NAME == __FILE__
  lambda_handler(event: nil, context: nil)
end
