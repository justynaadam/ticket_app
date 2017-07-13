Capybara.register_driver :chrome do |app|
  # optional
  client = Selenium::WebDriver::Remote::Http::Default.new
  # optional
  client.timeout = 120
  Capybara::Selenium::Driver.new(app, :browser => :chrome, :http_client => client)
end

Capybara.javascript_driver = :chrome
