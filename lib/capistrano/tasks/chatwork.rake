# Deploy notification to ChatWork

require 'chatwork'

if ENV['CHATWORK_API_KEY'] && ENV['CHATWORK_ROOM_ID']
  ChatWork.api_key = ENV['CHATWORK_API_KEY']

  # https://github.com/mitukiii/capistrano-chatwork/blob/master/lib/capistrano-chatwork/tasks/capistrano-chatwork.rake
  namespace :chatwork do
    task :notify_deploy_started do
      notify("#{fetch(:application)}(#{fetch(:rails_env)})をデプロイしています", "#{release_commits}")
    end

    task :notify_deploy_finished do
      notify("#{fetch(:application)}(#{fetch(:rails_env)})をデプロイしました")
    end

    task :notify_deploy_failed do
      notify("#{fetch(:application)}(#{fetch(:rails_env)})をデプロイできませんでした")
    end

    def notify(title, message=nil)
      message = "\n" if message.nil?
      body = "[info][title]#{title}[/title]#{message}[/info]"
      ChatWork::Message.create(room_id: ENV['CHATWORK_ROOM_ID'], body: body) 
    end

    # http://qiita.com/ysk_1031/items/91010b8e6d5c995e23c7
    def release_commits
      commits_str = `cap #{fetch(:rails_env)} deploy:pending`
      commits = commits_str.split("\n\n")
      return if commits.size.zero?
      messages = []
      commits.each_with_index{|ci, index| messages << ci.strip if index.odd? }
      commiters = []
      commit_hashes = []
      commits.each_with_index do |info, index|
        next if index.odd?
        info_ary = info.split("\n")
        hash_elem = info_ary[0]
        commiter_elem = info_ary.select{|elem| elem if elem =~ /Author:/ }.first
        match_index = (commiter_elem =~ /</)
        commiters << commiter_elem[8..(match_index - 2)]
        commit_hashes << hash_elem[7..-1]
      end

      repo = fetch(:repo_url).gsub(/\Agit@github\.com:|\.git\z/, '')
      release_info = ''
      (commits.length / 2).times do |n|
        release_info <<
          "- #{messages[n]} by #{commiters[n]}\n" \
          "  https://github.com/#{repo}/commit/#{commit_hashes[n]}\n" \
          "\n"
      end
      release_info
    end
  end

  before 'deploy:starting',  'chatwork:notify_deploy_started'
  after  'deploy:finishing', 'chatwork:notify_deploy_finished'
  after  'deploy:failed',    'chatwork:notify_deploy_failed'
end

