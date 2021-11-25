require 'rails_helper'

feature 'register and login', type: :feature do
    scenario "register" do
        visit "users/sign_up"

        expect(page).to have_content("Sign up")

        within("#new_user") do
            fill_in "Email", with: "foobar@example.com"
            fill_in "Password", with: "12345678"
            fill_in "Password confirmation", with: "12345678"
        end

        click_button "Sign up"
        
        expect(page).to have_content("Welcome! You have signed up successfully.")

        user = User.last
        expect(user.email).to eq("foobar@example.com")
    end

    scenario "login and logout" do
        user = User.create! email: "foobar@example.com", password: '12345678'

        visit 'users/sign_in'

        within("#new_user") do
            fill_in "Email", with: "foobar@example.com"
            fill_in "Password", with: "12345678"
        end

        click_button "Log in"
        expect(page).to have_content("Signed in successfully")

        click_link "登出"
        expect(page).to have_content("Signed out successfully")
    end
end