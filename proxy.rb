require 'webrick'
require 'webrick/httpproxy'

document_root = File.expand_path(File.dirname(__FILE__))+'/htdocs'

rubybin = 'C:/Ruby192/bin/ruby.exe'

# address => http://127.0.0.1:10080

handler = Proc.new() {|req,res|
	status="start"
	case status
	when "start"
		res.set_redirect(WEBrick::HTTPStatus::TemporaryRedirect,"http://127.0.0.1:10080/start.htm")
	when "yet"
		res.set_redirect(WEBrick::HTTPStatus::TemporaryRedirect,"http://127.0.0.1:10080/yet.htm")
	when "finish"
		#res.set_redirect(WEBrick::HTTPStatus::TemporaryRedirect,req.request_uri)
	end
}

server = WEBrick::HTTPProxyServer.new({
	:DocumentRoot	=>	document_root,
	:BindAddress	=>	'0.0.0.0',
	:CGIInterpreter => rubybin,
	:Port			=>	10080,
	:ProxyContentHandler => handler
})


['/cgi-bin/setting.rb'].each {|cgi_file|
	server.mount(cgi_file, WEBrick::HTTPServlet::CGIHandler, document_root + cgi_file)
}

['INT'].each{|signal|
	Signal.trap(signal){server.shutdown}
}

server.start