require 'singleton'

class GitInfo
  include Singleton

  def initialize
    @git_info_text = File.read(git_info_file_path) if available?
  end

  def git_info_file_path
    File.join(Rails.root, 'git.info')
  end

  def available?
    File.exist?(git_info_file_path) and (not File.read(git_info_file_path).blank?)
  end

  def commit_id
    @git_info_text.match(/commit ([\S]{40})/)[1] rescue nil
  end

  def author
    @git_info_text.match(/Author: (.+) <(.+)>$/)[1..2] rescue nil
  end

  def timestamp
    Time.parse(@git_info_text.match(/Date: (.+)$/)[1].strip) rescue nil
  end

  def message
    @git_info_text.match(/Date:(.+)$(.+)\z/m)[1].split(/\n\n/).pop.strip rescue nil
  end

  def branch
    @git_info_text.match(/Branch: (.+)$/)[1] rescue nil
  end

end