# access functionality
puts "SHOWING FUNCTIONALITY"
binding.pry

test_engine "rspec"
    # ModiFile.instance

file_extension_to_examine ".txt"
modified_files
file_extension_to_examine ".rb"
modified_files


test_engine "test_unit"
test_files
test_files safety: false
test_engine "rspec"


modified_files

branch

# execute checks
puts "DOING CHECKS"

expect(linting).to be_acceptable
expect(linting).to be_acceptable_enough(2)
expect(branch).to_not be_trunk
expect(tests).to pass
# expect(tests verbose: true).to pass




    # expect(test_files safety: false).to 
    # expect(face_palm).to_not include('console.log', 'BaseJob', 'binding.pry')