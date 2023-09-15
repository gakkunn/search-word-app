class BlocksController < ApplicationController
    MAX_SEARCH_WORD_LENGTH = 30

    require 'open-uri'
    require 'nokogiri'
    
    before_action :authenticate_user!
    before_action :set_block, only: %i[ show edit update destroy ]

    def index
        @blocks = current_user.blocks
    end
  
    # 検索画面
    def show
        @urlsets = @block.urlsets
        @search_word = params[:search]

        if search_word_too_long?
            render :show
            return
        end
        
        @each_word_counts = @search_word.present? ? search_in_addresses : {}
    end
  
    def new
        @block = current_user.blocks.build
        Block::MAX_URLSETS_COUNT.times { @block.urlsets.build }
    end
  
    def create
        @block = current_user.blocks.build(block_params)

        if @block.save
            redirect_to blocks_path, notice: 'Block and URL were successfully created.'
        else
            required_urlsets = Block::MAX_URLSETS_COUNT - @block.urlsets.size
            required_urlsets.times { @block.urlsets.build }
            render :new
        end
    end
  
    def edit
        existing_urlsets_count = @block.urlsets.count
        (Block::MAX_URLSETS_COUNT - existing_urlsets_count).times { @block.urlsets.build }
    end
  
    def update
        params[:block][:urlsets_attributes].each do |index, urlset_attrs|
            if urlset_attrs[:id] && urlset_attrs[:name].blank? && urlset_attrs[:address].blank?
                urlset_attrs[:_destroy] = '1'
            end
        end

        if @block.update(block_params)
            redirect_to blocks_path, notice: 'Block and URL were successfully updated.'
        else
            required_urlsets = Block::MAX_URLSETS_COUNT - @block.urlsets.size
            required_urlsets.times { @block.urlsets.build }
            render :edit
        end
    end
  
    def destroy
        if @block.destroy
          redirect_to blocks_path, notice: 'Block was successfully deleted.'
        else
          redirect_to blocks_path, alert: 'Failed to delete the block.'
        end
    end

    private
        def set_block
            @block = current_user.blocks.find(params[:id])
        end

        def block_params
            params.require(:block).permit(:name, urlsets_attributes: [:id, :name, :address, :_destroy])
        end

        def search_word_too_long?
            if @search_word.present? && @search_word.length > MAX_SEARCH_WORD_LENGTH
                flash.now[:alert] = "検索ワードは#{MAX_SEARCH_WORD_LENGTH}文字以下で入力してください。"
                true
            else
                false
            end
        end

        def search_in_addresses
            urlset_word_counts = {}
            error_messages = []
        
            @block.urlsets.each do |urlset|
                begin
                    url = URI.parse(urlset.address)

                    url.query = nil
                    url.fragment = nil

                    # スキーム後クエリ、フラグメント、特殊文字が続く場合に対して
                    # ex)  http:#fragment,http:/#(@)*!
                    if url.host.nil?
                        log_and_store_error(urlset, "正しいURLを入力してください: #{urlset.address}", error_messages, urlset_word_counts)
                        next
                    end

                    # URLに明示的にポート番号が指定されている場合に対して
                    # ex) https://example.com:8080
                    unless [80, 443].include?(url.port)
                        log_and_store_error(urlset, "許可しないポートへのアクセスです: #{urlset.address}", error_messages, urlset_word_counts)
                        next
                    end

                    doc = Nokogiri::HTML(open(url, redirect: false, read_timeout: 1).read)
                    doc.search('script, style').remove
                    visible_text = doc.text  
                    count = visible_text.downcase.scan(@search_word.downcase).count
                    urlset_word_counts[urlset.id] = count if count >= 0

                rescue OpenURI::HTTPRedirect, OpenURI::HTTPError, SocketError, Timeout::Error, Errno::ENOENT => e
                    handle_exception(e, urlset, error_messages, urlset_word_counts)
                end
                sleep(0.1)
            end
            
            unless error_messages.empty?
                flash.now[:alert] = error_messages.join("<br>").html_safe
            end
        
            urlset_word_counts
        end

        def handle_exception(exception, urlset, error_messages, urlset_word_counts)
            error = case exception
                    when OpenURI::HTTPRedirect
                        "リダイレクトが検出されました"
                    when OpenURI::HTTPError
                        "404 Not Found, 500 Internal Server Errorgaが検出されました"
                    when SocketError
                        "接続エラーが検出されました(存在するURLですか？)"
                    when Timeout::Error
                        "タイムアウトエラーが検出されました"
                    when Errno::ENOENT
                        "存在しないURLが検出されました"
                    else
                        "エラーが検出されました"
                    end
        
            error_message = "#{error}：#{urlset.address}"
            log_and_store_error(urlset, error_message, error_messages, urlset_word_counts)
        end

        def log_and_store_error(urlset, message, error_messages, urlset_word_counts)
            Rails.logger.error(message)
            error_messages << message
            urlset_word_counts[urlset.id] = -1
        end
          
end
