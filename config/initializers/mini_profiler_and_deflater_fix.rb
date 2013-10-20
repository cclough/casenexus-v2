
# Mini-profiler-Delfater fix - https://github.com/SamSaffron/MiniProfiler/issues/131
if Rails.env == 'production'
  Rails.application.config.middleware.delete(Rack::MiniProfiler)
  Rails.application.config.middleware.insert_after(HerokuDeflater::SkipBinary, Rack::MiniProfiler)
end