# frozen_string_literal: true

module Lokka
  module PermalinkHelper
    def custom_permalink?
      Option.permalink_enabled == 'true'
    end

    def custom_permalink_format
      Option.permalink_format.scan(/%(\w+?)%/).flatten
    end

    def custom_permalink_path(param)
      Option.permalink_format.gsub(/%(\w+?)%/) { param[$1.to_sym] }
    end

    def custom_permalink_parse(path)
      format = Option.permalink_format
      regexp = Regexp.compile(Regexp.escape(format).gsub(/\%(\w+?)\%/) { "(?<#{$1}>.+?)" } + "$")
      match_data = regexp.match(path)
      return nil if match_data.nil?
      match_data.names.inject({}) do |hash, key|
        hash[key.to_sym] = match_data[key]
        hash
      end
    end

    def custom_permalink_entry(path)
      match_data = custom_permalink_parse(path)
      return nil if match_data.nil?

      if match_data[:id] or match_data[:slug]
        entries = if match_data[:id]
                    Entry.where(id: match_data[:id])
                  elsif match_data[:slug]
                    Entry.where(slug: match_data[:slug])
                  end
        entries.first
      else
        start_date = Time.local(
          match_data[:year],
          match_data[:month]  || 1,
          match_data[:day]    || 1,
          match_data[:hour]   || 0,
          match_data[:minute] || 0,
          match_data[:second] || 0
        )
        end_date= Time.local(
          match_data[:year],
          match_data[:month]  || 12,
          match_data[:day]    || 31,
          match_data[:hour]   || 23,
          match_data[:minute] || 59,
          match_data[:second] || 59
        )
        Entry.where(created_at: (start_date..end_date)).first
      end
    end

    def custom_permalink_fix(path)
      r = custom_permalink_parse(path)
      url_changed = false
      [:year, :month, :day, :hour, :minute, :second].each do |k|
        i = (k == :year ? 4 : 2)
        (r[k] = r[k].rjust(i,'0'); url_changed = true) if r[k] && r[k].size < i
      end

      custom_permalink_path(r) if url_changed
    rescue => e
      nil
    end

    class << self
      include Lokka::PermalinkHelper
    end
  end
end
