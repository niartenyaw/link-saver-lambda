require 'git'
require 'date'

NAME = 'saved-links'
GITHUB_URI = 'https://github.com/niartenyaw/appacademy-slack-saved-links'
SLACK_CHANNEL_HISTORY_URL = 'https://slack.com/api/channels.history'

CHANNELS_ID_MAP = {
  'ethics' => 'CBJE3MNGK'
}

CHANNELS_TO_SAVE = [
  'ethics'
]

def lambda_handler(event:, context:)
  `rm -rf #{NAME}`

  g = Git.clone(GITHUB_URI, NAME)
  CHANNELS_TO_SAVE.each do |channel|
    filename = File.join(NAME, channel)
    File.open(filename) do |f|
      lines = f.readlines
      link_hash = Hash.new
      lines.each { |line| link_hash[line] = true }


    end
  end

  { statusCode: 200 }
end

if $PROGRAM_NAME == __FILE__
  lambda_handler(event: nil, context: nil)
end
