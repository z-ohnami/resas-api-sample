require 'faraday'
require 'json'

API_KEY=ENV['RESAS_API_KEY']
host = 'https://opendata.resas-portal.go.jp'
endpoint = '/api/v1/tourism/attractions'
query_string = '?prefCode=13&cityCode='

tokyo_23regions = {
  # 13101 => '千代田区',
  # 13102 => '中央区',
  # 13103 => '港区',
  # 13104 => '新宿区',
  # 13105 => '文京区',
  # 13106 => '台東区',
  # 13107 => '墨田区',
  # 13108 => '江東区',
  # 13109 => '品川区',
  # 13110 => '目黒区',
  # 13111 => '大田区',
  # 13112 => '世田谷区',
  # 13113 => '渋谷区',
  # 13114 => '中野区',
  # 13115 => '杉並区',
  # 13116 => '豊島区',
  # 13117 => '北区',
  # 13118 => '荒川区',
  # 13119 => '板橋区',
  # 13120 => '練馬区',
  # 13121 => '足立区',
  # 13122 => '葛飾区',
  13123 => '江戸川区'
}

response_group = tokyo_23regions.each_with_object({}) do |(cityCode, cityName), h|
  response = Faraday.new.get do |req|
    req.url "#{host}#{endpoint}#{query_string}#{cityCode}"
    req.headers['X-API-KEY'] = API_KEY
  end

  amounts = JSON.parse(response.body)
  h[cityName] = amounts['result'].nil? ? [] : amounts['result']['data'].map { |d| d['resourceName'] }
end

p ['区名', '観光資源数', '資源名'].join(',')

response_group.each do |cityName, amounts|
  p [cityName, amounts.size, amounts.join(' | ')].join(',')
end
