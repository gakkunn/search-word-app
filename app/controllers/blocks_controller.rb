class BlocksController < ApplicationController
    require 'open-uri'
    require 'nokogiri'
    
    before_action :set_block, only: %i[ show edit update destroy ]

    def index
        @blocks = current_user.blocks
    end
  
    def show
        @urlsets = @block.urlsets
        @search_word = params[:search]
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

        def search_in_addresses
            urlset_word_counts = {}
            has_error = false
        
            @block.urlsets.each do |urlset|
                begin
                    doc = Nokogiri::HTML(open(urlset.address))
                    doc.search('script, style').remove
                    visible_text = doc.text  
                    count = visible_text.downcase.scan(@search_word.downcase).count
                    urlset_word_counts[urlset.id] = count if count >= 0
                rescue OpenURI::HTTPError, SocketError, Timeout::Error, Errno::ENOENT => e
                    has_error = true
                    urlset_word_counts[urlset.id] = -1
                    Rails.logger.error("Error fetching URL #{urlset.address}: #{e.message}")
                end
            end
            
            flash.now[:alert] = "存在しないURLが含まれている可能性があります" if has_error
            return urlset_word_counts
        end
end
