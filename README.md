# SafeCommit

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/safe_commit`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add safe_commit

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install safe_commit

Add an executable binstub 
```
touch ./bin/safe_commit_checks
chmod 755 ./bin/safe_commit_checks
```
with contents
```
#!/usr/bin/env ruby
# frozen_string_literal: true
APP_PATH = File.expand_path('../config/application', __dir__)
require_relative '../config/boot'
require "rails/commands"

include SafeCommit

require "pry"

$stdin.reopen("/dev/tty")

class SafeCommitRunner
  def self.run_from_file(file_path)
    load(file_path)
  end

  # Add other methods for the DSL example, if needed.
end

if ARGV[0]
  SafeCommitRunner.run_from_file(ARGV[0])
else
  print <<-SAMPLE
  #---DSL usage example
  file_extension_to_examine ".rb"
  test_engine "rspec"
  trunk_branch "master"
  expect(branch).to_not be_trunk
  test_files
  test_files safety: false
  modified_files
  branch
  linting
  expect(linting).to be_acceptable
  expect(linting).to be_acceptable_enough(2)
  expect(branch).to_not be_trunk
  expect(tests(safety: false, verbose: true)).to pass
  #---
  SAMPLE

  Pry.start
end

```

use the binstub in your pre-commit hooks.
```
touch .git/hooks/pre-commit
chmod 755 .git/hooks/pre-commit
echo "./bin/safe_commit_checks .before_commit.rb" >> .git/hooks/pre-commit
```

create your safe commit checks in `.before_commit.rb`
with some sample checks
```
file_extension_to_examine ".rb"
test_engine "rspec"
trunk_branch "master"

expect(branch).to_not be_trunk
expect(linting).to be_acceptable
```

## Usage

```
[1] pry(main)> branch
=> "main\n"
[2] pry(main)> modified_files
=> ["lib/safe_commit.rb"]
[3] pry(main)> test_files
=> []
[4] pry(main)> test_files safety: false
=> ["lib/safe_commit_spec.rb"]
```

```
test_engine "rspec"
file_extension_to_examine ".rb"
trunk_branch "master"

test_files
test_files safety: false

modified_files
branch
linting

expect(linting).to be_acceptable
expect(linting).to be_acceptable_enough(2)
expect(branch).to_not be_trunk
expect(tests).to pass
```


### To receive refactoring suggestions from ChatGPT

set the OPEN API KEY in `.env` (see `.sample.env`)

```
SAFE_COMMIT_OPENAI_API_KEY=sk-api-key
```

Add the following DSL command to your `.before_commit.rb`

```
suggest_refactors
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/safe_commit. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/safe_commit/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SafeCommit project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/safe_commit/blob/main/CODE_OF_CONDUCT.md).
