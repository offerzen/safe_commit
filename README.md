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
require_relative "../lib/safe_commit"
include SafeCommit

require "pry"

if ARGV[0]
  eval(File.read(ARGV[0]))
  return
end

Pry.start
```

use the binstub in your pre-commit hooks.
```
touch .git/hooks/pre-commit
chmod 755 .git/hooks/pre-commit
echo "./bin/safe_commit_checks .before_commit.sc" >> .git/hooks/pre-commit
```

create your safe commit checks in `.before_commit.sc`
with some sample checks
```
file_extension_to_examine ".rb"
test_engine "rspec"
trunk_branch "main"

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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/safe_commit. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/safe_commit/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SafeCommit project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/safe_commit/blob/main/CODE_OF_CONDUCT.md).
