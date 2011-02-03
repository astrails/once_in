require 'helper'

class TestOnceIn < Test::Unit::TestCase
  def test_should_run_the_code_1st_time
    x = 0
    once_in(1) {x += 1}
    assert_equal 1, x
  end

  def test_should_not_run_the_code_2nd_time
    x = 0
    2.times do
      once_in(1) {x += 1}
    end
    assert_equal 1, x
  end

  def test_should_run_the_code_2nd_time_after_delay
    x = 0
    2.times do
      once_in(1) {x += 1}
      sleep(1)
    end
    assert_equal 2, x
  end
end
