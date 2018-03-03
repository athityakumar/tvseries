require 'mechanize'

module TVSeries
  module Scrapers
    class Base
      def initialize
        @episodes = []
        @season_list = []
        @agent = Mechanize.new
      end

      def internet_connection_exists?(website='https://www.google.com/')
        begin
          @agent.get(website)
        rescue Exception => e
          puts "No internet connection found, aborting."
          return false
        end
        puts "Internet connection successful, starting the scraping process."
        return true
      end

      private

      def remove_all_between(string , char1, char2)
        while string.index(char1) && string.index(char2)
          index1 = string.index(char1)
          index2 = string.index(char2)
          string = string[0...index1] + string[index2+1..-1]
        end

        string
      end
    end
  end
end
