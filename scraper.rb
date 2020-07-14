
require 'open-uri'
require 'nokogiri'

def fetch_movies_urls
  url = "https://www.imdb.com/chart/top"

  html_file = open(url).read
  html_doc = Nokogiri::HTML(html_file)
  urls = [
  ]
  html_doc.search('.lister-list .titleColumn a').first(5).each do |element|
  # puts element.text.strip
  movie_url = element.attribute('href').value
  urls << "https://www.imdb.com#{movie_url}"
  end
  return urls
end



def scrap_movie(url)
  html_file = open(url).read
  html_doc = Nokogiri::HTML(html_file)

  storyline = html_doc.search('.summary_text').text.strip
  director = html_doc.search('.credit_summary_item a').first.text.strip
  title_and_date = html_doc.search('.title_wrapper h1').text.strip
  title = title_and_date.split(':')[0]
  year = title_and_date.split('(')[1].chop.to_i
  cast = html_doc.search('.cast_list .primary_photo + td a').first(3).map do |element|
    # + td permet d acceder à la balise td en dessous de la classe primary_photo
    element.text.strip
  end

  movie = {
    cast: cast,
    director: director,
    storyline: storyline,
    title: title,
    year: year
  }
end
