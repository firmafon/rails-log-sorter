require "test_helper"

class TestLog < MiniTest::Unit::TestCase
  include RailsLogSorter

  def test_parsing_log_file
    log = Log.new_with_file("test/example.log")

    r1 = log.requests[0]
    assert_equal "BlogController#index", r1.action
    assert_equal 100.2, r1.runtime

    r2 = log.requests[1]
    assert_equal "BlogController#show", r2.action
    assert_equal 200.18, r2.runtime

    r3 = log.requests[2]
    assert_equal "BlogController#index", r3.action
    assert_equal 300.3, r3.runtime
  end

  def test_find_slowest
    log = Log.new_with_file("test/example.log")

    slow = log.find_slowest("BlogController#index")

    assert_equal 2, slow.size

    assert_equal 300.3, slow[0].runtime
    assert_equal 100.2, slow[1].runtime
  end
end
