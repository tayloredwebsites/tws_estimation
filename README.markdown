# Authorization and Authentication by Application and Roles startup application

This is a startup application by [Taylored Web Sites](http://www.tayloredwebsites.com).

Authorization will be provided by using the users table (using active record).

To Do: Authentication will allow the application to control access to actions based upon the user's rights (multiple roles can be assigned to a user).  For performance purposes, roles are stored in a single string field in the users table.  Uses the  [CanCan](https://github.com/ryanb/cancan) authorization library.

Test Driven Development has been used from the inception of this site.  [Rspec](https://github.com/dchelimsky/rspec) and [Capybara](https://github.com/jnicklas/capybara) are the primary libraries used for testing.  I just happened to use Rspec because I had already developed techniques of testing using it, as opposed to unit test.  Possible To Do: Duplicate Rspec tests into Unit Test tests.

The HTML has been coded with DIVs and CSS, using a variation of a grail (holy grail of layouts, not using grids) three column layout.

Error displays are built into the layouts and standardized field display styles.  Active record errors will automatically display appropriately in the views, at the field or base levels.

All text displayed to the user has been internationalized using ruby hash methods (config/locales/en.rb).




