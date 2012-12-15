# fluent-plugin-http-post

## Overview

### HttpPostOutput

fluentからpostリクエストを投げるoutput-pluginです。
[fluentd-plugin-ikachan](https://github.com/tagomoris/fluent-plugin-ikachan)を流用させていただきました。この場を借りてお礼申し上げます。

## Usage

### Configuration

    <match **>
    type http_post
    post_uri http://example/post
    out_keys tag,time,msg,msg2
    time_key time
    time_format %Y/%m/%d %H:%M:%S
    tag_key tag
    _extra_postparam1 ex_param1
    _extra_postparam2 ex_param2
    _extra_postparam3 ex_param3
    </match>

上記のようにconfを作ると、`http://example/post`に対し以下のパラメータをPOSTします。

    {
    "tag"=>"#{matched tag}",
    "time"=>"2012/12/15 10:13:54",
    "msg"=>"param msg1",
    "msg2"=>"param msg1",
    "extra_postparam1"=>"ex_param1",
    "extra_postparam2"=>"ex_param2",
    "extra_postparam3"=>"ex_param3"
    }


