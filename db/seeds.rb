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
site_urls = ["https://www.amazon.fr/cycle-Fondation-I-Fondation/dp/2070360539/ref=sr_1_1?s=books&ie=UTF8&qid=1517651130&sr=1-1&keywords=azimov+isaac+fondation",
"https://www.amazon.fr/cycle-robots-1/dp/2290055956/ref=sr_1_1?s=books&ie=UTF8&qid=1517675452&sr=1-1&keywords=azimov",
"https://www.amazon.fr/cycle-Fondation-III-Seconde/dp/2070360520/ref=sr_1_5?s=books&ie=UTF8&qid=1517675476&sr=1-5&keywords=azimov",
"https://www.amazon.fr/cycle-Fondation-II-Fondation-Empire/dp/2070360555/ref=sr_1_3?ie=UTF8&qid=1517676794&sr=8-3&keywords=asimov",
"https://www.amazon.fr/robot-qui-r%C3%AAvait-Isaac-Asimov/dp/2290317152/ref=sr_1_7?s=books&ie=UTF8&qid=1517676858&sr=1-7&keywords=azimov",
"https://www.amazon.fr/dp/2070379663/ref=sxbs_sxwds-stvp_2?pf_rd_m=A1X6FK5RDHNB96&pf_rd_p=1566153327&pd_rd_wg=utopm&pf_rd_r=NAVERWN9J3K33D0ZNM16&pf_rd_s=desktop-sx-bottom-slot&pf_rd_t=301&pd_rd_i=2070379663&pd_rd_w=uGlE0&pf_rd_i=azimov&pd_rd_r=7080d532-652d-4602-8e73-fb9b854e56e9&ie=UTF8&qid=1517676858&sr=2"]
site_urls.each do |site_url|
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

    unless result["objects"].first["images"].blank?
      Image.create(product_id: product.id,
        url: result["objects"].first["images"].first["url"],
        naturalHeight: result["objects"].first["images"].first["naturalHeight"],
        naturalWidth: result["objects"].first["images"].first["naturalWidth"],
        width: result["objects"].first["images"].first["width"],
        height: result["objects"].first["images"].first["height"])
    end

    unless result["objects"].first["specs"].blank?
      Statistic.create(product_id: product.id,
        language: result["objects"].first["specs"]["langue"],
        collection: result["objects"].first["specs"]["collection"],
        poche: result["objects"].first["specs"]["poche"],
        dimension: result["objects"].first["specs"]["dimensions_du_produit"],
        classement: result["objects"].first["specs"]["classement_des_meilleures_ventes_damazon"])
    end
  end
end
