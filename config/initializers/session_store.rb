Rails.application.config.session_store :cookie_store,
                                       key: "_session_id",
                                       expire_after: 2.minutes,
                                       same_site: :none,
                                       secure: true
