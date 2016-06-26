require 'bundler'
require 'open-uri'
require 'yaml'
Bundler.require

url = 'http://www.irasutoya.com/feeds/posts/default'
count = 1
# url = 'https://www.blogger.com/feeds/8749391503645026985/posts/default?start-index=1501&max-results=25'
# count = 61

loop do
  puts [nil, '=' * 50, url, "page = #{count}", '=' * 50, nil, nil].join("\n")

  begin
    page = Nokogiri::HTML(open(url))

    entries = page.css('entry')
    next_link = page.css('link[@rel="next"]')

    entries.each { |entry|
      content = Nokogiri::HTML(entry.css('content').text)

      id           = entry.css('id').text.scan(/\.post-(\d+)\z/)[0][0]
      title        = entry.css('title').text
      published_at = Time.parse(entry.css('published').text)
      categories   = entry.css('category').map { |category| category.attributes['term'].value }
      entry_url    = entry.css('link[@rel="alternate"]').first.attributes['href'].value
      description  = content.css('div').last&.text
      images       = content.css('img')

      images.each_with_index { |image, index|
        alphabet = ('a'..'z').to_a[index]
        basename = "#{id}#{alphabet}"
        filepath = "data/#{basename}.yml"

        image_url = image.attributes['src'].value
        image_alt = image.attributes['alt']&.value

        data = {
          'title'        => title,
          'description'  => description,
          'categories'   => categories,
          'entry_url'    => entry_url,
          'image_url'    => image_url,
          'image_alt'    => image_alt,
          'published_at' => published_at
        }

        puts data.merge('filepath' => filepath, 'processed_at' => Time.now)

        File.write(filepath, YAML.dump(data))
      }
    }

    break if next_link.empty?

    url = next_link.first.attributes['href'].value.sub('http://', 'https://')
    count += 1
    sleep 5
  rescue => error
    puts error
    binding.pry
  end
end
