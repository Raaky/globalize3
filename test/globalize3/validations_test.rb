require File.expand_path('../../test_helper', __FILE__)

class ValidationsTest < Test::Unit::TestCase
  def teardown
    super
    Validatee.reset_callbacks(:validate)
  end
  
  # TODO
  #
  # test "a record with valid values on non-default locale validates" do
  #   assert Post.create(:title => 'foo', :locale => :de).valid?
  # end

  test "update_attribute succeeds with valid values" do
    post = Post.create(:title => 'foo')
    post.update_attributes(:title => 'baz')
    assert post.valid?
    assert_equal 'baz', Post.first.title
  end

  test "update_attributes fails with invalid values" do
    post = Post.create(:title => 'foo')
    assert !post.update_attributes(:title => '')
    assert !post.valid?
    assert_not_nil post.reload.attributes['title']
    assert_equal 'foo', post.title
  end

  test "validates_presence_of" do
    Validatee.class_eval { validates_presence_of :string }
    assert !Validatee.new.valid?
    assert Validatee.new(:string => 'foo').valid?
  end

  test "validates_confirmation_of" do
    Validatee.class_eval { validates_confirmation_of :string }
    assert !Validatee.new(:string => 'foo', :string_confirmation => 'bar').valid?
    assert Validatee.new(:string => 'foo', :string_confirmation => 'foo').valid?
  end

  test "validates_acceptance_of" do
    Validatee.class_eval { validates_acceptance_of :string, :accept => '1' }
    assert !Validatee.new(:string => '0').valid?
    assert Validatee.new(:string => '1').valid?
  end
  
  test "validates_length_of (:is)" do
    Validatee.class_eval { validates_length_of :string, :is => 1 }
    assert !Validatee.new(:string => 'aa').valid?
    assert Validatee.new(:string => 'a').valid?
  end
  
  test "validates_format_of" do
    Validatee.class_eval { validates_format_of :string, :with => /^\d+$/ }
    assert !Validatee.new(:string => 'a').valid?
    assert Validatee.new(:string => '1').valid?
  end
  
  test "validates_inclusion_of" do
    Validatee.class_eval { validates_inclusion_of :string, :in => %(a) }
    assert !Validatee.new(:string => 'b').valid?
    assert Validatee.new(:string => 'a').valid?
  end
  
  test "validates_exclusion_of" do
    Validatee.class_eval { validates_exclusion_of :string, :in => %(b) }
    assert !Validatee.new(:string => 'b').valid?
    assert Validatee.new(:string => 'a').valid?
  end
  
  test "validates_numericality_of" do
    Validatee.class_eval { validates_numericality_of :string }
    assert !Validatee.new(:string => 'a').valid?
    assert Validatee.new(:string => '1').valid?
  end

  # This doesn't pass and Rails' validates_uniqueness_of implementation doesn't
  # seem to be extensible easily. One can work around that by either defining
  # a custom validation on the Validatee model itself, or by using validates_uniqueness_of
  # on Validatee::Translation.
  # 
  # test "validates_uniqueness_of" do
  #   Validatee.class_eval { validates_uniqueness_of :string }
  #   Validatee.create!(:string => 'a')
  #   assert !Validatee.new(:string => 'a').valid?
  #   assert Validatee.new(:string => 'b').valid?
  # end

  # test "validates_associated" do
  # end
end