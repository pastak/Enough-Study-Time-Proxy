#!C:/Ruby192/bin/ruby.exe

require 'cgi'
require 'sqlite3'

#db = SQLite3::Database.new("studytime.db")
cgi = CGI.new
time = cgi['time']
puts "Content-Type: text/html\n\n"
puts time+"hour!!!!!"
