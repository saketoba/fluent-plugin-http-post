class Fluent::HttpPostOutput < Fluent::Output
  Fluent::Plugin.register_output('http_post', self)

  config_param :post_uri, :string
  config_param :out_keys, :string
  config_param :time_key, :string, :default => nil
  config_param :time_format, :string, :default => nil
  config_param :tag_key, :string, :default => 'tag'
  config_param :post_uri_parsed, :default => nil
  config_param :extra_postparams, :default => Hash.new

  def initialize
    super
    require 'net/http'
    require 'uri'
  end

  def assign_exparams conf
    conf.each do |k, v|
        if k =~ /^_/
            @extra_postparams[k.sub(/^_/,'')] = v
        end
    end
  end

  def configure(conf)
    super
    @post_uri_parsed = URI.parse @post_uri
    @out_keys = conf['out_keys'].split(',')
    assign_exparams conf
    if @time_key
      if @time_format
        f = @time_format
        tf = Fluent::TimeFormatter.new(f, @localtime)
        @time_format_proc = tf.method(:format)
        @time_parse_proc = Proc.new {|str| Time.strptime(str, f).to_i }
      else
        @time_format_proc = Proc.new {|time| time.to_s }
        @time_parse_proc = Proc.new {|str| str.to_i }
      end
    end
  end

  def start
  end

  def shutdown
  end

  def emit(tag, es, chain)
    post_params_list = []

    es.each {|time,record|
      values = []
      values = @out_keys.map do |key|
        case key
        when @time_key
          @time_format_proc.call(time)
        when @tag_key
          tag
        else
          record[key].to_s
        end
      end

      post_params = Hash[@out_keys.zip(values)]
      post_params.merge!(@extra_postparams)

      post_params_list.push(post_params)
    }

    post_params_list.each do |post_params|
      begin
        res = Net::HTTP.post_form(@post_uri_parsed, post_params)
      rescue
        $log.warn "out_http_post: failed to send notice to post,#{@post_uri}, params: #{post_params}"
      end
    end

    chain.next
  end

end
