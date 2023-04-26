# SafeCommit - A Ruby DSL for Ensuring Code Quality

SafeCommit is a Ruby Domain-Specific Language (DSL) designed to streamline code quality assurance by running tests, performing linting, and suggesting refactors before committing changes to a Git repository. It serves as a centralized solution for defining and utilizing pre-commit hooks, eliminating the need to copy and paste them across multiple repositories or manage them locally on individual machines.

The DSL facilitates easy distribution of pre-commit functionality and enables users to receive updates seamlessly. It can be extended to promote the adoption of new patterns in a codebase, such as avoiding inheritance from BaseJob. This feature helps developers stay informed about new migrations, even in large codebases where they may not be top of mind. Linting runs on changes files only, so that you can focus on leaving the code in a better place than you found it, rather than taking on historical styleguide offenses.

For extensive test suites, running all tests locally may not be practical. SafeCommit can efficiently identify modified or new Ruby files and execute their corresponding test files based on standard naming conventions, saving time and ensuring code quality.

In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/safe_commit`. To experiment with that code, run `bin/console` for an interactive prompt.

## Installation
To start using SafeCommit, include the provided file in your project and make sure to have the required dependencies installed.

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
  puts "Get started with SafeCommit at https://github.com/offerzen/safe_commit"

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
### To receive refactoring suggestions from ChatGPT

set the OPEN API KEY in `.env` (see `.sample.env`)

```
SAFE_COMMIT_OPENAI_API_KEY=sk-api-key
```

Add the following DSL command to your `.before_commit.rb`

```
suggest_refactors
```


## SafeCommit DSL Usage

### Assertions

```ruby
expect(guess)
```
Create an expectation with a guess that will be checked against actual results later.

### Testing DSL
```ruby
test_engine(setting)
```
Set the testing engine to the provided setting.

```ruby
tests(options = { safety: true, verbose: false })
```
Run tests with the specified options. By default, it runs tests with safety enabled and minimal output.

### Git DSL
```ruby
file_extension_to_examine(setting)
```
Set the file extension to be examined when analyzing modified files.

```ruby
modified_files
```
Retrieve a list of modified files in the current Git repository.

```ruby
test_files(options = { safety: true })
```
Retrieve a list of test files based on the provided options. By default, it returns test files with safety enabled.

```ruby
branch
```
Get the current Git branch.

```ruby
trunk_branch(setting)
```
Set the trunk or protected branch to the provided setting.

```ruby
be_trunk
```
Get the trunk or protected branch setting.

### Linting DSL
```ruby
linting
```
Run RuboCop linting on modified files and return the output.

```ruby
be_acceptable_enough(threshold = 0)
```
Check if the number of offenses is below the specified threshold. By default, the threshold is 0.

```ruby
be_acceptable
```
Check if there are no offenses detected in the linting output.

### Custom Gotchas
```ruby
no_presence_of(pattern, message = nil)
```
Check if the provided pattern is present in the staged changes of the Git repository. If found, display the message.

```ruby
suggest_refactors
```
Suggest refactors for each modified file using GPT-4. Requires the SAFE_COMMIT_OPENAI_API_KEY environment variable to be set with a valid OpenAI API key.


### Summary

Features include:
- `modified_files`: show a listing of all modified files (configure with `file_extension_to_examine`)
- `test_files`: show a listing of all test files that correspond to the file changes you've made
- `tests`: run the tests using the configured `test_engine` 
- `no_presence_of`: asserts that given string is not present in the changes staged for commit.
- `expect(<actual>).to `: asserts that actual is *equal to* the expected value.
- supported expected values
  - Any custom string or integer value
  - `pass`: syntactic sugar for the parsed result of the rspec test suite output
  - `be_acceptable`: wrapper for rubocop parsed output
  - `be_acceptable_enough(<limit>)`: tolerates a limited number of violations.
  - `be_trunk`: wrapper for common trunk branch names, *main* or *master*.
- `suggest_refactors`: when used, sends your .rb to ChatGPT asks for readability refactor suggestions.

### Examples

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
