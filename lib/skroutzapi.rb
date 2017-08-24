class Skroutzapi
  def initialize
    @skroutz = Skroutz::Client.new(Rails.application.secrets.skroutz_identifier,Rails.application.secrets.skroutz_secret)
  end

  def search_sku_by_id(id)
  	begin
  	  @skroutz.skus.find(id)
  	rescue => e 
  	  false
    end  	
  end

  def find_sku_category(id)
    begin
      @skroutz.categories.find(id)
    rescue => e 
      false
    end   
  end
end