#!/usr/bin/env ruby

module PostStatusFilter
  HIDDEN_STATUS = 'hidden'.freeze

  def self.hidden?(post)
    post.data['status'].to_s.downcase == HIDDEN_STATUS || post.data['hidden'] == true
  end
end

Jekyll::Hooks.register :site, :post_read do |site|
  site.collections['posts'].docs.reject! { |post| PostStatusFilter.hidden?(post) }
end
