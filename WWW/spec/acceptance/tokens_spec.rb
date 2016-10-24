# encoding: utf-8
require 'spec_helper'

feature 'tokens form' do
 	scenario 'adding tokens', js: true do
 		visit new_token_path
 		click_on 'Sign up'
 		fill_in 'Email', with: 'abc@efg.hi'
 		fill_in 'Password', with: 'zaxscdvf'
 		fill_in 'Password confirmation', with: 'zaxscdvf'
 		click_on 'Sign up'
 		Token.count.should == 0
 		visit new_token_path
 		fill_in 'Nazwa tokenu', with: 'newtoken'
 		fill_in 'Lokalizacja', with: 'warszawa'
 		click_on 'Zapisz'
 		Token.count.should == 1
 	end

 	scenario 'see all tokens' do
 		token1 = create :token, token_name: 'newwtok'
 		token2 = create :token, token_name: 'otherwtok'
 		visit tokens_path
 		click_on 'Sign up'
 		fill_in 'Email', with: 'ab2c@efg.hi'
 		fill_in 'Password', with: 'zaxscdvf'
 		fill_in 'Password confirmation', with: 'zaxscdvf'
 		click_on 'Sign up'
 		page.should have_content token1.token_name
 		page.should have_content token2.token_name
 	end
end
	