# Estimation of systems/component costs

This is a startup application by [Taylored Web Sites](http://www.tayloredwebsites.com).

Estimation System:

It is assumed that what is being estimated can be broken down into a number of systems, each of which is made up of components:

* Components have particular kinds of costs associated with them, which are managed by "Component Types".
* Systems have particular sets of Components associated with them, which are managed "System Components".
* Estimates are a combination of Systems (with their corresponding Components), plus an "Overhead System".

People who have maintenance privileges can enter the base set of items used to create an Estimate:

* Components Types (Description, sort order, has costs, has hours, etc.)
* Components (Component Type, Description)
* Systems (Description, sort order, required)
* System Components (Description, required)

General Philosophy / Approaches:

1. Readability and Documentation goes before DRY (don't repeat yourself).
	* Still working on what this means in detail, but functionality should not be hidden / obfuscated.
2. Code is written in parallel with tests.
	* Tests should have both business and technical requirements.
	* Each test should have a validation for each significant step through the test.
	* Model, Controller and Integration/View (using Capybara) tests are used to cover the application requirements.
3. Authorization is provided by using the users table (using active record).
	* A CRUD (Create/Read/Update/Delete) interface is provided.  Deactivation and Reactivation are additionally provided.
	* Records cannot be Deleted unless already Deactivated.
	* An audit trail of transactions will be available for some tables, and the Deactivation is necessary to keep the audit trail valid.
4. An HTML layout Framework has been coded with DIVs and CSS, using a variation of a grail (holy grail of layouts, not using grids) three column layout.
5. Error displays are built into the layouts and standardized field display styles.
	* Active record errors will automatically display appropriately in the views, at the field or base levels.
6. All text displayed to the user has been internationalized using locales (config/locales/en.rb).
7. Role Based Authentication has been coded in the Model (multiple roles can be assigned to a user).
	* For performance purposes, roles are stored in a single string field in the users table.
	* Uses the  [CanCan](https://github.com/ryanb/cancan) authorization library.
	* Role base Authentication has a default role for all users that are not logged in.
	* Administrators are able to maintain user roles, users are not allowed to modify their own roles.
8. Designed for multiple sub-applications
	* This application will be used to provide access to a number of different sub-applications.
	* A shared database will be used to simplify the inter-sub-application communications.
	* Role based authorization can specify the role a user has within each (or all) sub-application.
	* To this end, each role will specify the sub-application that it corresponds with.

Future Features:

* An audit trail of transactions will be available for some tables, utilizing the Deactivation feature.
* Reset Password feature
