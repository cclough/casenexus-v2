config.middleware.delete(Rack::MiniProfiler)
config.middleware.insert_after(HerokuDeflater::SkipBinary, Rack::MiniProfiler)