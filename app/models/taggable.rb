module Taggable
  module ClassMethods
        ### TAG STUFF - one day make a polymorphic (repeated in Book)
    def tagged_with(name)
      self.joins(:taggings).where(taggings: {tag_id: Tag.find_by_name!(name).id})
      # Tag.find_by_name!(name).id
      # questions
    end

    def tag_counts
      Tag.select("tags.id, tags.name, count(taggings.tag_id) as count").
        joins(:taggings).group("taggings.tag_id, tags.id, tags.name")
    end

  end
  
  module InstanceMethods
    def tag_list
      tags.map(&:name).join(", ")
    end

    def tag_list=(names)
      names.pop #added pop and shift to remove first and last array items as chosen always including a blank field for unknown reason
      names.shift
      self.tags = names.map do |n| # here a split(", ") is removed to enable chosen multiple input
        Tag.where(name: n.strip).first_or_create!
      end
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end
