class ArticlesController < ApplicationController
  def index
    @articles = Article.all(params[:page])
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def edit
    @article = Article.find(params[:id])
  end

  def create
    @article = Article.create(params[:article])
    
    if @article.errors
      render action: 'new'
    else
      redirect_to article_path(@article.id), notice: 'Article was successfully created.'
    end
  end

  def update
    @article = Article.update(params[:id], params[:article])

    if @article.errors
      render action: 'edit'
    else
      redirect_to article_path(@article.id), notice: 'Article was successfully updated.'
    end
  end

  def destroy
    Article.destroy(params[:id])

    redirect_to articles_url
  end
end
