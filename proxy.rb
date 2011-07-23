require 'webrick'
require 'webrick/httpproxy'

document_root = './htdocs'
rubybin = 'C:/Ruby192/bin/ruby.exe'

handler = Proc.new() {|req,res|
	res.set_redirect(WEBrick::HTTPStatus::TemporaryRedirect,"http://127.0.0.1:10080/cgi-bin/index.rb")
}

server = WEBrick::HTTPProxyServer.new({
	:DocumentRoot	=>	document_root,
	:BindAddress	=>	'0.0.0.0',
	:CGIInterpreter => rubybin,
	:Port			=>	10080,
	:ProxyContentHandler => handler
})

['/cgi-bin/index.rb'].each {|cgi_file|
	server.mount(cgi_file, WEBrick::HTTPServlet::CGIHandler, document_root + cgi_file)
}

['INT','TERM'].each{|signal|
	Signal.trap(signal){server.shutdown}
}

server.start