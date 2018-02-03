# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'net/http'
require 'cgi'


diffbot_url = "https://api.diffbot.com/v3/product?"
token = "99cd23dd5e77e80143caa1427540458a"
site_url = "https://www.amazon.fr/cycle-Fondation-I-Fondation/dp/2070360539/ref=sr_1_1?s=books&ie=UTF8&qid=1517651130&sr=1-1&keywords=azimov+isaac+fondation"
encoded_url = ERB::Util.url_encode(site_url)
uri = URI(diffbot_url+"token="+token+"&url="+encoded_url)
path = diffbot_url+"token="+token+"&url="+encoded_url
http = Net::HTTP.new(uri.host, 80)
request = Net::HTTP::Get.new(uri.request_uri)
r = http.request(request)

if r.kind_of? Net::HTTPSuccess
  result = JSON.parse(r.body)

  product = Product.create(title: result["objects"].first["title"],
    text: result["objects"].first["text"],
    price: result["objects"].first["offerPriceDetails"]["amount"])

  result["objects"].first["images"].each do |image|
    Image.create(product_id: product.id,
      url: image["url"],
      naturalHeight: image["naturalHeight"],
      naturalWidth: image["naturalWidth"],
      width: image["width"],
      height: image["height"],
      position: Image.by_product(product).size + 1)
  end

  p product
  p result["objects"].first["specs"]
  Statistic.create(product_id: product.id,
    language: result["objects"].first["specs"]["langue"],
    collection: result["objects"].first["specs"]["collection"],
    poche: result["objects"].first["specs"]["poche"],
    dimension: result["objects"].first["specs"]["dimensions_du_produit"],
    classement: result["objects"].first["specs"]["classement_des_meilleures_ventes_damazon"])


end
