class BlocksController < ApplicationController
    before_action :set_block, only: %i[ show edit update destroy ]

    def index
        @blocks = current_user.blocks
    end
  
    def show
    end
  
    def new
        @block = current_user.blocks.build
    end
  
    def create
        @block = current_user.blocks.build(block_params)

        if @block.save
            redirect_to blocks_path, notice: 'Block and URL were successfully created.'
        else
            render :new
        end
    end
  
    def edit
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
      params.require(:block).permit(:name)
    end
end
