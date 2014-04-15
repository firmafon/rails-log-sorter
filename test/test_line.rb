require "test_helper"

class TestLine < MiniTest::Unit::TestCase
  include RailsLogSorter

  def test_started_line
    line = Line.new('2014-03-04 10:00:00.100 [INFO ] Started GET "/" (pid:1)')

    assert_equal 'Started GET "/"', line.message
    assert_equal '1', line.pid
    assert_equal :started, line.type
  end

  def test_processing_line
    line = Line.new('2014-03-04 10:00:00.100 [INFO ] Processing by FooController#index as HTML (pid:1)')

    assert_equal '1', line.pid
    assert_equal :processing, line.type
    assert_equal "FooController#index", line.action
  end

  def test_completed_line
    line = Line.new('2014-03-04 10:00:00.100 [INFO ] Completed 200 OK in 50.1ms (pid:1)')

    assert_equal '1', line.pid
    assert_equal :completed, line.type
    assert_equal 50.1, line.runtime
  end

  def test_completed_line_with_breakdown
    line = Line.new('2014-03-04 10:26:47.736 [INFO ] Completed 200 OK in 1837.5ms (Views: 1808.8ms | ActiveRecord: 5.1ms) (pid:18269)')

    assert_equal '18269', line.pid
    assert_equal :completed, line.type
    assert_equal 1837.5, line.runtime
  end

  def test_log_line
    line = Line.new('2014-03-04 10:00:00.100 [INFO ] This is a log (pid:1)')

    assert_equal '1', line.pid
    assert_equal :log, line.type
  end

  def test_unknown_line
    line = Line.new('Connecting to database')

    assert_equal :unknown, line.type
  end
end
