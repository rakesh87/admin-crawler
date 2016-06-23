require 'open-uri'

class SnapdealService

  def initialize(product_url:)
    @product_url = product_url
    @page = Nokogiri::HTML(open(product_url))
    properties_list
  end

  attr_reader :product_url, :page, :prop_list

  def to_json
    {
      vendor: vendor,
      title: title,
      real_price: int_price,
      offer_price: int_offer_price,
      categories: categories,
      stock: stock,
      image_link: image_link,
      page_link: page_link,
      sku: sku,
      brand: brand,
      material: material,
      color:  colour
    }
  end


  private

    def vendor
      "Snapdeal"
    end

    def title
      page.css('h1')[0].text
    end

    def real_price
      page.css('.pdpCutPrice').text.strip
    end

    def offer_price
      page.css('.payBlkBig').text.strip
    end

    def categories
      categories = []
      page.css("#breadCrumbWrapper a[itemprop=url]").each do |value|
        categories << value.text.strip
      end
      categories.map!(&:strip)
      categories = categories.reject { |c| ['home', 'Home', 'HOME'].include?(c) }
      categories
    end

    def stock
      page.css("div[class='message-alert alert-error soldDiscontAlert']").size == 0 ? 1 : 0
    end

    def image_link
      page.at_css("#bx-slider-left-image-panel img")["src"]
    end

    def page_link
      page.at_css("link[rel='canonical']")['href']
    end

    def sku
      prop_list.fetch("SUPC", "")
    end

    def brand
      brand = prop_list.fetch("Brand", "")
      if brand.present?
        brand.strip
      else
        ''
      end
    end

    def material
      material = prop_list.fetch("Material", "")
      if material.present?
        material.strip
      elsif prop_list.fetch("Primary Material", "").present?
        material = prop_list.fetch("Primary Material")
        material.strip
      else
        ''
      end
    end

    def colour
      colour = prop_list.fetch("Color", "")
      if colour.present?
        colour.strip
      else
        ''
      end
    end

    def int_price
      if real_price.present?
        real_price.split("Rs.")[1].delete(',').squish.to_i
      else
        0
      end
    end

    def int_offer_price
      if offer_price.present?
        offer_price.delete(',').squish.to_i
      else
        0
      end
    end

    def properties_list

      @prop_list ||= Hash.new
      page.css(".dtls-list").css("li").each do |prop|
        props = prop.text.split(":")
        @prop_list[props[0].try("strip")] = props[1].try("strip")
      end

      page.css(".product-spec tr").each do |prop|
        td = prop.css("td")
        if td.size == 2
          @prop_list[td[0].text.try("strip")] = td[1].text.try("strip")
        end
      end
      @prop_list

    end

end
