file_extension_to_examine ".rb"
test_engine "rspec"
trunk_branch "main"

expect(branch).to_not be_trunk
expect(linting).to be_acceptable_enough(2)
expect(tests(safety: false, verbose: false)).to pass