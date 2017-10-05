module RedmineTags
  module Patches
    module AutoCompletesControllerPatch
      def self.included(base)
        base.send :include, InstanceMethods
      end

      module InstanceMethods
        def issue_tags
          if User.current.allowed_to?(:issue_edit_tags, @project) 
            @name = params[:q].to_s
            @tags = Issue.available_tags project: @project, name_like: @name
            render layout: false, partial: 'tag_list'
          else
            render layout: false, partial: 'empty_list'
          end
        end

        def wiki_tags
          if User.current.allowed_to?(:wiki_edit_tags, @project) 
            @name = params[:q].to_s
            @tags = WikiPage.available_tags project: @project, name_like: @name
            render layout: false, partial: 'tag_list'
          else
            render layout: false, partial: 'empty_list'
          end
        end
      end
    end
  end
end

base = AutoCompletesController
patch = RedmineTags::Patches::AutoCompletesControllerPatch
base.send(:include, patch) unless base.included_modules.include?(patch)
