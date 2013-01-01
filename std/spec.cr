$spec_context = []
$spec_results = []
$spec_count = 0
$spec_failures = 0
$spec_manual_results = false

def it(description)
  $spec_context << description
  it { yield }
  $spec_context.pop
end

def it
  $spec_success = true
  $spec_count += 1
  yield
  if $spec_success
    print '.'
  else
    print 'F'
    $spec_failures += 1
  end
end

def describe(description)
  $spec_context << description
  yield
  $spec_context.pop
  spec_results unless $spec_manual_results || !$spec_context.empty?
end

def spec_results
  puts
  puts $spec_results.join "\n"
  puts "#{$spec_count} examples, #{$spec_failures} failures"
end

class Object
  def should(expectation)
    unless expectation.match self
      $spec_results << "In #{$spec_context.join(" ")}, #{expectation.failure_message}"
      $spec_success = false
    end
  end

  def should_not(expectation)
    if expectation.match self
      $spec_results << "In #{$spec_context.join(" ")}, #{expectation.negative_failure_message}"
      $spec_success = false
    end
  end
end

class EqualExpectation
  def initialize(value)
    @value = value
  end

  def match(value)
    @target = value
    value == @value
  end

  def failure_message
    "expected #{@value.inspect} but got #{@target.inspect}"
  end

  def negative_failure_message
    "didn't expect #{@value.inspect} but got #{@target.inspect}"
  end
end

def eq(value)
  EqualExpectation.new value
end

def be_true
  eq(true)
end

def be_false
  eq(false)
end
