require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading)     { 'Help' }
    let(:page_title)  { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading)     { 'About' }
    let(:page_title)  { 'About Us' }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading)     { 'Contact' }
    let(:page_title)  { 'Contact' }

    it_should_behave_like "all static pages"
  end

  describe "Right links on the layout" do
    before { visit root_path }

    describe "About page" do
      before { click_link "About" }
      it { should have_titles('About Us') }
    end

    describe "Help page" do
      before { click_link "Help" }
      it { should have_titles('Help') }
    end

    describe "Contact page" do
      before { click_link "Contact" }
      it { should have_titles('Contact') }
    end

    describe "Signup page" do
      before { click_link "Sign up now!" }
      it { should have_titles('Sign up') }
    end

    describe "sample app page" do
      before { click_link "sample app" }
      it { should have_titles('') }
    end
  end
end
