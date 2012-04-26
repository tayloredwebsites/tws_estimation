# Authorization and Authentication by Application and Roles startup application

This is a startup application by [Taylored Web Sites](http://www.tayloredwebsites.com).

Philosophy / Approaches:

1. Readability and Documentation goes before DRY (don't repeat yourself).
    >Still working on what this means in detail, but functionality should not be hidden / obfuscated.
2. Code is written in parallel with tests.
    >Tests should have both business and technical requirements.
    >Each test should have a validation for each significant step through the test.
    >Model, Controller and Integration/View (using Capybara) tests are used to cover the application requirements.
3. Authorization is provided by using the users table (using active record).
    >A CRUD (Create/Read/Update/Delete) interface is provided.  Deactivation and Reactivation are additionally provided.
    >Records cannot be Deleted unless already Deactivated.
    >An audit trail of transactions will be available for some tables, and the Deactivation is necessary to keep the audit trail valid.
4. An HTML layout Framework has been coded with DIVs and CSS, using a variation of a grail (holy grail of layouts, not using grids) three column layout.
5. Error displays are built into the layouts and standardized field display styles.
    >Active record errors will automatically display appropriately in the views, at the field or base levels.
6. All text displayed to the user has been internationalized using locales (config/locales/en.rb).
7. Role Based Authentication has been coded in the Model (multiple roles can be assigned to a user).
    >For performance purposes, roles are stored in a single string field in the users table.
    >Uses the  [CanCan](https://github.com/ryanb/cancan) authorization library.
2. Role base Authentication has a default role for all users that are not logged in.
 

Next Steps.

1. Role Based Authentication will be coded into the Views and tested in the integration tests next
2. This application will be used to provide access to a number of different systems.
    >I am using a shared database to simplify the inter-system communications.
    >Authentication, Authorization and common data will be most easily available to each system.
    >Hopefully this can be modularized by putting this code into gems or engines.
4. Thus the Authentication system must have a role based system that can specify the role a user has within each (or all) system.
    >To this end, each role will specify the application that it corresponds with.



