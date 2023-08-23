class ApplicationController < ActionController::Base
    def hello
        render html: "ソースコード変更されているか確認"
      end
end
