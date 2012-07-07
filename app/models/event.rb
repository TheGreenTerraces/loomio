class Event < ActiveRecord::Base
  KINDS = %w[new_discussion new_comment new_motion new_vote motion_blocked]

  has_many :notifications
  belongs_to :discussion
  belongs_to :comment
  belongs_to :motion
  belongs_to :vote

  validates_inclusion_of :kind, :in => KINDS

  attr_accessible :kind, :discussion, :comment, :motion, :vote

  def self.new_discussion!(discussion)
    event = create!(:kind => "new_discussion", :discussion => discussion)
    discussion.group_users.each do |user|
      unless user == discussion.author
        event.notifications.create! :user => user
      end
    end
    event
  end

  def self.new_comment!(comment)
    event = create!(:kind => "new_comment", :comment => comment)
    comment.discussion_participants.each do |user|
      unless user == comment.user
        event.notifications.create! :user => user
      end
    end
    event
  end

  def self.new_motion!(motion)
    event = create!(:kind => "new_motion", :motion => motion)
    motion.group_users.each do |user|
      unless user == motion.author
        event.notifications.create! :user => user
      end
    end
    event
  end

  def self.new_vote!(vote)
    event = create!(:kind => "new_vote", :vote => vote)
    begin
      unless vote.user == vote.motion_author
        event.notifications.create! :user => vote.motion_author
      end
      unless vote.user == vote.discussion_author
        event.notifications.create! :user => vote.discussion_author
      end
    rescue ActiveRecord::RecordInvalid => error
      # Catches error if we are trying to create duplicate notifications for
      # the same user (i.e. if motion author and discussion author are same person)
      raise unless error.message =~ /User has already been taken/
    end
    event
  end

  def self.motion_blocked!(vote)
    event = create!(:kind => "motion_blocked", :vote => vote)
    vote.group_users.each do |user|
      unless user == vote.user
        event.notifications.create! :user => user
      end
    end
    event
  end
end