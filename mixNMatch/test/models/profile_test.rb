#require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
#   test "the truth" do
#     assert true
#   end

    MALE = 0
    FEMALE = 1
    EVERYONE = 2
    NONBINARY = 2

    profile1 = Profile.new
    profile1.id = 1
    profile1.gender = 0
    profile1.preference = 0

    profile2 = Profile.new
    profile2.id = 0
    profile2.gender = 0
    profile2.preference = 0

    pref = 0
    og = 0
    op = 0
    test "Male matches" do
        profile1.gender = MALE
        pref = 0
        while pref < 3 do
            profile1.preference = pref
            if pref == 0
                og = 0
                while og < 3 do
                    profile2.gender = og
                    if og == 0 || og == 2
                        profile2.preference = MALE
                        assert profile1.compatible profile2
                        assert profile2.compatible profile1
                        profile2.preference = EVERYONE
                        assert profile1.compatible profile2
                        assert profile2.compatible profile1
                    end
                    og += 1
                end 
            elsif pref == 1
                og = 0
                while og < 3 do
                    profile2.gender = og
                    if og == 1 || og == 2
                        profile2.preference = MALE
                        assert profile1.compatible profile2
                        assert profile2.compatible profile1
                        profile2.preference = EVERYONE
                        assert profile1.compatible profile2
                        assert profile2.compatible profile1
                    end
                    og += 1
                end 
            elsif pref == 2
                og = 0
                while og < 3 do
                    profile2.gender = og

                    profile2.preference = MALE
                    assert profile1.compatible profile2
                    assert profile2.compatible profile1
                    profile2.preference = EVERYONE
                    assert profile1.compatible profile2
                    assert profile2.compatible profile1

                    og += 1
                end
            end 
            pref += 1
        end
    end

    test "Female matches" do
        profile1.gender = FEMALE
        pref = 0
        while pref < 3 do
            profile1.preference = pref
            if pref == 0
                og = 0
                while og < 3 do
                    profile2.gender = og
                    if og == 0 || og == 2
                        profile2.preference = FEMALE
                        assert profile1.compatible profile2
                        assert profile2.compatible profile1
                        profile2.preference = EVERYONE
                        assert profile1.compatible profile2
                        assert profile2.compatible profile1
                    end
                    og += 1
                end 
            elsif pref == 1
                og = 0
                while og < 3 do
                    profile2.gender = og
                    if og == 1 || og == 2
                        profile2.preference = FEMALE
                        assert profile1.compatible profile2
                        assert profile2.compatible profile1
                        profile2.preference = EVERYONE
                        assert profile1.compatible profile2
                        assert profile2.compatible profile1
                    end
                    og += 1
                end 
            elsif pref == 2
                og = 0
                while og < 3 do
                    profile2.gender = og

                    profile2.preference = FEMALE
                    assert profile1.compatible profile2
                    assert profile2.compatible profile1
                    profile2.preference = EVERYONE
                    assert profile1.compatible profile2
                    assert profile2.compatible profile1

                    og += 1
                end
            end 
            pref += 1
        end
    end

    test "Non-binary matches" do
        profile1.gender = NONBINARY
        pref = 0
        while pref < 3 do
            profile1.preference = pref
            if pref == 0
                profile2.gender = MALE
                    
                profile2.preference = MALE
                assert profile1.compatible profile2
                assert profile2.compatible profile1
                profile2.preference = FEMALE
                assert profile1.compatible profile2
                assert profile2.compatible profile1
                profile2.preference = EVERYONE
                assert profile1.compatible profile2
                assert profile2.compatible profile1
            elsif pref == 1
                profile2.gender = FEMALE
                    
                profile2.preference = MALE
                assert profile1.compatible profile2
                assert profile2.compatible profile1
                profile2.preference = FEMALE
                assert profile1.compatible profile2
                assert profile2.compatible profile1
                profile2.preference = EVERYONE
                assert profile1.compatible profile2
                assert profile2.compatible profile1
            elsif pref == 2
                og = 0
                while og < 3 do
                    profile2.gender = og

                    profile2.preference = MALE
                    assert profile1.compatible profile2
                    assert profile2.compatible profile1
                    profile2.preference = FEMALE
                    assert profile1.compatible profile2
                    assert profile2.compatible profile1
                    profile2.preference = EVERYONE
                    assert profile1.compatible profile2
                    assert profile2.compatible profile1

                    og += 1
                end
            end 
            pref += 1
        end
    end
                    
end
