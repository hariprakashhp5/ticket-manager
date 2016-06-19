class BgWorker
  include Sidekiq::Worker
  sidekiq_options retry: true


  def perform(tracker_id)

  	headless=Headless.new
    headless.start  
    ticket = Tracker.find(tracker_id)
  	    driver = Selenium::WebDriver.for :firefox
  	    puts "browser open"
  	    driver.navigate.to "https://bankbazaarmail.zendesk.com/agent/tickets/"+ticket.ticket_id
  	    puts "waiting fo element"
  	    wait = Selenium::WebDriver::Wait.new(:timeout => 1000)
        iframe=driver.find_element(:css, 'body > div:nth-child(3) > iframe:nth-child(1)')
  	    wait.until { iframe.displayed? }
        puts "found"
        ##### LOGIN #####
        driver.switch_to.frame iframe
        driver.find_element(:id, 'user_email').send_key "data-ticket-grp@bankbazaar.com"
        driver.find_element(:id, 'user_password').send_key "Config123"
        driver.find_element(:css, '.button').click
        ##### SCRAPE #####
        wait.until{driver.find_element(:css, '.live.full').displayed?}
        subject=driver.find_element(:css, 'div.tab_text:nth-child(4)').attribute("textContent")
        puts subject
        #work_type=subject.scan(/\$ : (.+) -/).first.first.gsub(/[^0-9A-Za-z]/, '')
  	    date=driver.find_element(:css, '.live.full').attribute("title").split(" ").join(" ")
        puts date
        cd=DateTime.parse(date)
        ticket_owner=driver.find_element(:css, '.ember-view.sender').attribute("textContent").split(" ").first
        puts ticket_owner        
  	    driver.close
        headless.destroy

        ticket.update(:created => cd.strftime("%d-%m-%y %H:%M"), :owner=>ticket_owner, :disc=>subject)
    
  end
end