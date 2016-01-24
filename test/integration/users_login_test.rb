require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "login with valid information followed by logout" do
    get login_path # Go to login page
    post login_path, session: { email: @user.email, password: 'password' } # enter user data
    assert is_logged_in? # verify that the user is logged in
    assert_redirected_to @user # verify redirect to user page
    follow_redirect! # Go to user page
    assert_template 'users/show' # verify that the page is the users page
    assert_select "a[href=?]", login_path, count: 0 # verify that there are no login path links on the page (since we are already logged in)
    assert_select "a[href=?]", logout_path # verify that there is a logout link on the page
    assert_select "a[href=?]", user_path(@user) # verify that there is a link to the user's page
    delete logout_path # log out (HTTP delete method)
    assert_not is_logged_in?
    assert_redirected_to root_url
    # Simulate a user clicking a logout in a second window.
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path # verify that there is a login path link on the page (since we are not logged in)
    assert_select "a[href=?]", logout_path, count: 0 # verify that there are no logout links on the page
    assert_select "a[href=?]", user_path(@user), count: 0 # verify that there are no links to the user's page
  end

  test "user login" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: "",
                                  password: "" }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get '/'
    assert flash.empty?
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_nil cookies['remember_token']
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end
end
