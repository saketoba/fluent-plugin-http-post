require 'helper'

class HttpPostOutputTest < Test::Unit::TestCase
  POST_URI = 'http://localhosti'
  CONFIG = %[
    post_uri #{POST_URI}
    out_keys tag,time,msg,msg2
    time_key time
    time_format %Y/%m/%d %H:%M:%S
    tag_key tag
    _extra_postparam1 ex_param1
    _extra_postparam2 ex_param2
    _extra_postparam3 ex_param3
  ]

  def create_driver(conf=CONFIG,tag='test')
    Fluent::Test::OutputTestDriver.new(Fluent::HttpPostOutput, tag).configure(conf)
  end

  def test_configure
    d = create_driver
    assert_equal URI.parse(POST_URI), d.instance.post_uri_parsed
    assert_equal "ex_param1",d.instance.extra_postparams["extra_postparam1"]
  end


  def test_notice
    # To test this code, launch http-post request acceptable server
    # on your own host
    d = create_driver
    time = Time.now.to_i
    d.run do
      d.emit({'msg' => "message from fluentd out_http_post: testing now", 'msg2' => "message2",'msg3' => "hogehogee"}, time)
      d.emit({'msg' => "message from fluentd out_http_post: testing second line"}, time)
    end
  end

end
