# bare minimum options to process a latex idx file and produce output
BARE_MINIMUM_XINDY_CMD = 'xindy -M latex -M latex-loc-fmts '

# Run xindy, provide minimal required configuration.
#
# Implementation mostly copied from aruba's
#   When /^I successfully run `(.*?)`(?: for up to ([\d.]+) seconds)?$/
When(/^I successfully run xindy with "(.*?)"$/) do |args|
  cmd = BARE_MINIMUM_XINDY_CMD + sanitize_text(args)
  run_command_and_stop(cmd, fail_on_error: true)
end
