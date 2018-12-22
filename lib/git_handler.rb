require 'git'
require 'date'

class GitHandler

  GITHUB_URI = 'https://github.com/niartenyaw/appacademy-slack-saved-links'.freeze

  def initialize(repo_location:)
    @repo_location = repo_location
  end

  def clone
    # Remove repo (or clone will throw error)
    `rm -rf #{repo_location}`

    @git = Git.clone(GITHUB_URI, repo_location)
  end

  def save
    return unless git.diff.size > 0
    git.add
    git.commit("Update from #{Time.now}")
    git.push("https://link-saver-bot:#{ENV["GITHUB_PASSWORD"]}@github.com/niartenyaw/appacademy-slack-saved-links.git")
    `rm -rf #{repo_location}`
  end

  private

  attr_reader :git, :repo_location
end
