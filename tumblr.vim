" Post Regular Post to Tumblr

if (exists("g:loaded_tumblr") && g:loaded_tumblr) || &cp
    finish
endif

let g:loaded_tumblr = 1

command! -nargs=0 TumblrPost exec("py post_normal()")

python <<EOF
import vim
from urllib import urlencode, urlopen

def get_body():
    body = "\n".join(vim.current.buffer[1:])
    return body

def get_title():
    first_line = vim.current.buffer[0]
    title = first_line.strip()
    return title

def post_normal():
    title = get_title()
    body = get_body()
    send_post(title, body)

def send_post(title, body):
    email = "TUMBLR LOGIN EMAIL"
    password = "TUMBLR PASSWORD"
    post_type = "regular"
    post_generator = "Vim"
    post_format = "html"
    twitter_message = title #edit this for custom message
    data = urlencode({"email": email, "password": password,
            "generator": post_generator,
            "format": post_format,
			# uncomment the next line to use a group blog
            #"group": "MYGROUPBLOG.tumblr.com",
            "send-to-twitter": twitter_message,
            "type": post_type,
            "title": title, "body": body})
    url = "http://www.tumblr.com/api/write"
    res = urlopen(url, data)
    if res.code == 201:
        print "Posted"
    if res.code == 403:
        print "Bad Authentication"
    if res.code == 400:
        print "Bad Request"

EOF

