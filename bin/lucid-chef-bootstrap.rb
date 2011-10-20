#!/bin/env ruby
`which neph` or exit 'neph not found! Did you bundle?'
target = "lucid-basic-restrap-auto-#{}"
`neph restrap #{target} '512 server' -c git@github.com:jodell/cookbooks.git -r basic.jodell`
`neph save #{target} lucid-basic-auto`
