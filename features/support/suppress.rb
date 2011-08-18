# Stop endless errors like
# http://stackoverflow.com/questions/3622394/ruby-1-9-2-strange-warning-when-running-cucumber-specs/3692773#3692773
# ~/.rvm/gems/ruby-1.9.2-p0@global/gems/rack-1.2.1/lib/rack/utils.rb:16:
# warning: regexp match /.../n against to UTF-8 string
$VERBOSE = nil
