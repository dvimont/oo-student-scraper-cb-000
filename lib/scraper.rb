require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  def self.scrape_index_page(index_url)
    scraped_students = Array.new

    index_page = Nokogiri::HTML(open(index_url))
    student_elements = index_page.css("div.roster-cards-container div.student-card a")
    student_elements.each{|student_element|
      student_attributes = Hash.new
      student_attributes[:name] =
          student_element.css("div.card-text-container h4.student-name").text
      student_attributes[:location] =
          student_element.css("div.card-text-container p.student-location").text
      student_attributes[:profile_url] = student_element.attribute("href").value
      scraped_students.push(student_attributes)
    }
    return scraped_students
  end

  # Social_icon_map maps social-symbol to corresponding src substring
  Social_icon_map = {
    twitter: "twitter", linkedin: "linkedin", github: "github", blog: "rss" }

  def self.scrape_profile_page(profile_url)
    scraped_student = Hash.new

    student_page = Nokogiri::HTML(open(profile_url))
    # link scraping
    link_elements = student_page.css("div.social-icon-container a")
    link_elements.each { |link_element|
      Social_icon_map.each { |symbol, src_substring|
        if link_element.css("img").attribute("src").value.include?(src_substring)
          scraped_student[symbol] = link_element.attribute("href").value
          break
        end
      }
    }
    # profile & bio scraping
    scraped_student[:profile_quote] =
        student_page.css("div.vitals-text-container div.profile-quote").text
    scraped_student[:bio] =
        student_page.css("div.bio-content div.description-holder p").text
    return scraped_student
  end
end
