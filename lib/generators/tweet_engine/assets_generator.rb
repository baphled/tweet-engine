module TweetEngine
  module Generators
    class AssetsGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      
      def copy_assets
        # Layout
        copy_file"app/views/layouts/tweet_engine.html.erb","app/views/layouts/tweet_engine.html.erb"
        
        # JavaScript
        copy_file"public/javascripts/functions.js","public/javascripts/functions.js"
        copy_file"public/javascripts/jquery.ui.timepicker.js","public/javascripts/jquery.ui.timepicker.js"
        copy_file"public/javascripts/jquery.wysiwyg.js","public/javascripts/jquery.wysiwyg.js"
        copy_file"public/javascripts/png_fix.js","public/javascripts/png_fix.js"
        copy_file"public/javascripts/visualize.jQuery.js","public/javascripts/visualize.jQuery.js"
        
        # Stylesheets
        copy_file"public/stylesheets/layout.css","public/stylesheets/layout.css"
        copy_file"public/stylesheets/styles.css","public/stylesheets/styles.css"
        copy_file"public/stylesheets/wysiwyg.css","public/stylesheets/wysiwyg.css"
        
        # Images
        copy_file"public/img/avatar.png"                 ,"public/img/avatar.png"
        copy_file"public/img/bg_body_left.png"           ,"public/img/bg_body_left.png"
        copy_file"public/img/bg_breadcrumb.png"          ,"public/img/bg_breadcrumb.png"
        copy_file"public/img/bg_btn_grey_lrg.png"        ,"public/img/bg_btn_grey_lrg.png"
        copy_file"public/img/bg_btn_grey_sml.png"        ,"public/img/bg_btn_grey_sml.png"
        copy_file"public/img/bg_buttons.png"             ,"public/img/bg_buttons.png"
        copy_file"public/img/bg_buttons_alternative.png" ,"public/img/bg_buttons_alternative.png"
        copy_file"public/img/bg_fade_blue_med.png"       ,"public/img/bg_fade_blue_med.png"
        copy_file"public/img/bg_fade_green_med.png"      ,"public/img/bg_fade_green_med.png"
        copy_file"public/img/bg_fade_green_sml.png"      ,"public/img/bg_fade_green_sml.png"
        copy_file"public/img/bg_fade_med.png"            ,"public/img/bg_fade_med.png"
        copy_file"public/img/bg_fade_red_med.png"        ,"public/img/bg_fade_red_med.png"
        copy_file"public/img/bg_fade_red_sml.png"        ,"public/img/bg_fade_red_sml.png"
        copy_file"public/img/bg_fade_sml.png"            ,"public/img/bg_fade_sml.png"
        copy_file"public/img/bg_fade_up.png"             ,"public/img/bg_fade_up.png"
        copy_file"public/img/bg_fade_yellow_med.png"     ,"public/img/bg_fade_yellow_med.png"
        copy_file"public/img/bg_footer.png"              ,"public/img/bg_footer.png"
        copy_file"public/img/bg_forgotten_password.png"  ,"public/img/bg_forgotten_password.png"
        copy_file"public/img/bg_grey_dark_med.png"       ,"public/img/bg_grey_dark_med.png"
        copy_file"public/img/bg_header.png"              ,"public/img/bg_header.png"
        copy_file"public/img/bg_heading.png"             ,"public/img/bg_heading.png"
        copy_file"public/img/bg_heading_alt.png"         ,"public/img/bg_heading_alt.png"
        copy_file"public/img/bg_left_spacer.png"         ,"public/img/bg_left_spacer.png"
        copy_file"public/img/bg_leftside.png"            ,"public/img/bg_leftside.png"
        copy_file"public/img/bg_login_box.png"           ,"public/img/bg_login_box.png"
        copy_file"public/img/bg_login_btn.png"           ,"public/img/bg_login_btn.png"
        copy_file"public/img/bg_login_header.png"        ,"public/img/bg_login_header.png"
        copy_file"public/img/bg_login_input.png"         ,"public/img/bg_login_input.png"
        copy_file"public/img/bg_login_page.png"          ,"public/img/bg_login_page.png"
        copy_file"public/img/bg_navigation.png"          ,"public/img/bg_navigation.png"
        copy_file"public/img/bg_navigation_link.png"     ,"public/img/bg_navigation_link.png"
        copy_file"public/img/bg_navigation_selected.png" ,"public/img/bg_navigation_selected.png"
        copy_file"public/img/bg_noticebox_grey.png"      ,"public/img/bg_noticebox_grey.png"
        copy_file"public/img/bg_noticebox_yellow.png"    ,"public/img/bg_noticebox_yellow.png"
        copy_file"public/img/bg_notify_count.png"        ,"public/img/bg_notify_count.png"
        copy_file"public/img/bg_td_alt.png"              ,"public/img/bg_td_alt.png"
        copy_file"public/img/bg_th.png"                  ,"public/img/bg_th.png"
        copy_file"public/img/bg_usage_green.png"         ,"public/img/bg_usage_green.png"
        copy_file"public/img/bg_usage_orange.png"        ,"public/img/bg_usage_orange.png"
        copy_file"public/img/bg_usage_red.png"           ,"public/img/bg_usage_red.png"
        copy_file"public/img/cp_logo.png"                ,"public/img/cp_logo.png"
        copy_file"public/img/cp_logo_login.png"          ,"public/img/cp_logo_login.png"
        copy_file"public/img/jquery.wysiwyg.gif"         ,"public/img/jquery.wysiwyg.gif"
        copy_file"public/img/loading.gif"                ,"public/img/loading.gif"
        copy_file"public/img/login_fade.png"             ,"public/img/login_fade.png"
        copy_file"public/img/icons/icon_approve.png"     ,"public/img/icons/icon_approve.png"
        copy_file"public/img/icons/icon_breadcrumb.png"  ,"public/img/icons/icon_breadcrumb.png"
        copy_file"public/img/icons/icon_bullet.png"      ,"public/img/icons/icon_bullet.png"
        copy_file"public/img/icons/icon_cross_sml.png"   ,"public/img/icons/icon_cross_sml.png"
        copy_file"public/img/icons/icon_delete.png"      ,"public/img/icons/icon_delete.png"
        copy_file"public/img/icons/icon_edit.png"        ,"public/img/icons/icon_edit.png"
        copy_file"public/img/icons/icon_error.png"       ,"public/img/icons/icon_error.png"
        copy_file"public/img/icons/icon_info.png"        ,"public/img/icons/icon_info.png"
        copy_file"public/img/icons/icon_missing.png"     ,"public/img/icons/icon_missing.png"
        copy_file"public/img/icons/icon_square_close.png","public/img/icons/icon_square_close.png"
        copy_file"public/img/icons/icon_success.png"     ,"public/img/icons/icon_success.png"
        copy_file"public/img/icons/icon_ticklist.png"    ,"public/img/icons/icon_ticklist.png"
        copy_file"public/img/icons/icon_unapprove.png"   ,"public/img/icons/icon_unapprove.png"
        copy_file"public/img/icons/icon_warning.png"     ,"public/img/icons/icon_warning.png"
      end
    end
  end
end