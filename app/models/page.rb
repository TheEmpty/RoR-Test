class Page < ActiveRecord::Base
  attr_accessible :title, :content, :published_on

  def published # leave off question mark, causes problems with APIs
    published_on? and published_on > Time.now.utc
  end

  def as_json(options={})
    super(methods: :published)
  end

  def to_xml(options={})
    super(methods: :published)
  end

  def total_words
    # One two one-word four
    count = title.split(/[a-z|\-]+/i).count
    count += content.split(/[a-z|\-]+/i).count
    count
  end
end
