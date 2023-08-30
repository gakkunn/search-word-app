class BlocksController < ApplicationController
    before_action :set_block, only: %i[ show edit update destroy ]

    def index
        @blocks = current_user.blocks
    end
  
    def show
        @urlsets = @block.urlsets
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
        if @block.update(block_params)
            redirect_to blocks_path, notice: 'Block and URL were successfully updated.'
        else
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
end
