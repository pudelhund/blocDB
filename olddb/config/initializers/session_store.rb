# Be sure to restart your server when you modify this file.

if Rails.env == 'development'
	expire = 120
else
	expire = 5
end

RoutenDb::Application.config.session_store :cookie_store, key: '_routen_db_session', :expire_after => expire.minutes

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# RoutenDb::Application.config.session_store :active_record_store