class ApplicationController < ActionController::Base
    def hello
        render html: "Hello, Worldビルド確認！"
      end
end
