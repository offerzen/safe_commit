file_extension_to_examine ".rb"
test_engine "rspec"
trunk_branch "main"

expect(branch).to_not be_trunk
