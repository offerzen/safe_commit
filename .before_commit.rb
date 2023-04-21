# frozen_string_literal: true

file_extension_to_examine ".rb"
test_engine "rspec"
trunk_branch "main"

no_presecence_of("binding.pry", "development breakpoint detected")
no_presecence_of("console.log", "development breakpoint detected")
message = <<~MSG
  [Deprecation warning] Some files include #{"BaseJob".colorize(:red)}.
  > Please follow the guidelines at
  > https://offerzen.slab.com/posts/approach-for-background-async-jobs-using-sidekiq-3dcjec7l#hl0b3-job-class
MSG
no_presecence_of("BaseJob", message)

expect(branch).to_not be_trunk
expect(linting).to be_acceptable
expect(tests(safety: false, verbose: false)).to pass

suggest_refactors
