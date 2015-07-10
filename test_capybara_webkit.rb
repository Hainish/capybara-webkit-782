Headless.new.start
session = Capybara::Session.new :webkit
session.visit("http://www.mikulski.senate.gov/contact")
