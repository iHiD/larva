require File.expand_path('../test_helper', __FILE__)

module Larva
  class UtilsTest < Minitest::Test
    def test_blank?
      assert "".blank?
      assert nil.blank?
      refute "foobar".blank?
      refute 0.blank?
    end

    def test_camelize
      assert_equal "Foobar", "foobar".camelize
      assert_equal "FooBar", "foo_bar".camelize
      assert_equal "Foo::Bar", "foo/bar".camelize
    end
  end
end

