class Article
  include HTTParty
  
  base_uri 'http://localhost:3001/api'
  basic_auth 'root', 'secret'
  headers 'Accept' => 'application/vnd.example.v1'
  format :json
  
  attr_accessor :id, :description, :published_at, :title, :category_names, :created_at, :updated_at, :errors
  
  def initialize(attributes = {})
    self.attributes = attributes
  end
  
  def attributes=(attributes)
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end
  
  def self.all(page)
    response = get('/articles', query: { page: page })
    
    if response.body
      articles = JSON.parse(response.body).map{|a| self.new(a) }
    end
    
    Kaminari::PaginatableArray.new(
      articles,
      {
        limit: response.headers['X-limit'].to_i ,
        offset: response.headers['X-offset'].to_i ,
        total_count: response.headers['X-total'].to_i
      }   
    )
  end
  
  def self.find(id)
    self.new JSON.parse(get("/articles/#{id}").body)
  end
  
  def self.create(params = {})
    format_resource_params(params)
    article = self.new params.merge(
      JSON.parse(post("/articles", body: { article: params }).body)
    )
  end
  
  def self.update(id, params = {})
    format_resource_params(params)
    body = put("/articles/#{id}", body: { article: params } ).body
    article = {}
    
    if body
      article = JSON.parse(body)
      article['id'] = id
      article = self.new params.merge(article)
    else
      article = self.find(id) 
    end
  end
  
  def self.destroy(id)
    delete "/articles/#{id}"
  end
  
  private
  
  def self.format_resource_params(params)
    params[:published_at] = Time.parse(params['published_at']) if params[:published_at]
  end
end
