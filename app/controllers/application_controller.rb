class ApplicationController < ActionController::Base
    def hello
        render html: "Hello, World!確認！"
      end
end
