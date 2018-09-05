class QuotesController < Rulers::Controller
    def a_quote
        render :a_quote, :noun => :winking
    end

    def quote_1
        # model logic
        quote_1 = Rulers::Model::FileModel.find(1)
        # render logic
        render :quote, :obj => quote_1
    end
    
    def index
        quotes = Rulers::Model::FileModel.all
        render :index, :quotes => quotes
    end

    def show
        # read "id" attribute from request query params
        quote = Rulers::Model::FileModel.find(params["id"])
        ua = request.user_agent
        render_response :quote, :obj => quote, :ua => ua
    end

    def post_test
        raise "NOT A POST!" unless request.post?
        "Params: #{request.params.inspect}"
    end

    def new_quote
        attrs = {
            "submitter" => "web user",
            "quote" => "A picture is worth a thousand pixels.",
            "attribution" => "Me"
        }
        m = Rulers::Model::FileModel.create attrs
        render :quote, :obj => m
    end
end