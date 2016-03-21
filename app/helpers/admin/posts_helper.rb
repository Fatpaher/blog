module Admin
  module PostsHelper
    def link_to_change_status(post, status, &block)
      link_to status_change_admin_post_path(post, status: status),
        class: "btn btn-default",
        data: { confirm: "Are you sure?" },
        &block
    end
  end
end
