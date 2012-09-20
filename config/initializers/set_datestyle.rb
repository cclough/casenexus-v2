# Needed for heroku's postgres - otherwise doesn't understand date format in sample_data
ActiveRecord::Base.connection.execute 'SET DATESTYLE TO PostgreSQL,European;'