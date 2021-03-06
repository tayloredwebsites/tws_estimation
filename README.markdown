# Estimation of Assembly/Component costs #

This is an application by [Taylored Web Sites](http://www.tayloredwebsites.com).
This software is distributed under the [MIT license](MIT-LICENSE)

## General Project Note ##

* This is a very complex database driven application.  Focus has been on creating a stable and error free environment.  This project is a reasonably good representation of the quality of my database skills.
* Client has not asked/paid for a better user interface (they got this for a song).  This site uses minimal javascript or ajax, and will has graceful degredation without javascript.  Entering data will not have properly reflected calculations and totals till the update is done.  There was no Usability study or Designer input.  Please do not think this reflects the quality of my Web User Interface skills.
* There are a number of areas that I would improve (if the client pays, or I end up forking this into another project).  Mostly I would enhance the audit trail features.  I am not happy with the existing auditing gems (which is why I am currently using my deactivated module and custom scaffolding), and hope to create one of my own.
* There is minimal documentation on this project, and have created custom user docs for the client. I have not shared the current user docs until I spend the time to develop and document the dummy data on Heroku.  I will not be sharing the specialized Assemblies, components or component types that I am protecting for my client.
* If you are interested in this project, or wish to ask me any questions, I will be glad to help.

## Estimation System: ##

__It is assumed that what is being estimated can be broken down into a number of Assemblies, each of which is made up of components:__

* Components have particular kinds of costs associated with them, which are managed by "Component Types".
* Assemblies have particular sets of Components associated with them, which are managed "Assembly Components".
* Estimates are a combination of Assemblies (with their corresponding Components).

__People who have maintenance privileges can enter the base set of items used to create an Estimate:__

* Components Types (Description, sort order, has costs, has hours, etc.)
* Components (Component Type, Description)
* Modules (Description, sort order, required)
* Module Components (Description, required)

__This system is table driven, so there is a lot of flexibility built into it:__

* Standard items to consider in the quote are available by choosing a required Assembly and required Component.
* Overhead items to consider in the quote are available by creating an overhead Component and/or Component Type.
* Totaling of components are achieved with features built into the Component Types and Components.
* Calculations are possible using subtotals (grouped by component types) which are added to or multiplied by a default or entered value.


## General Philosophy / Approaches: ##

1. Readability and Documentation goes before DRY (don't repeat yourself).
    * Still working on what this means in detail, but functionality should not be hidden / obfuscated.
		* Encapsulation is good, as long as it is reasonably easy to customize the encapsulated features.
2. Code is written in parallel with tests.
    * Tests should have both business and technical requirements.
    * Each test should have a validation for each significant step through the test.
    * Model, Controller and Integration/View (using Capybara) tests are used to cover the application requirements.
3. Authorization is provided by using the users table (using active record).
    * A CRUD (Create/Read/Update/Delete) interface is provided.  Deactivation and Reactivation are additionally provided.
    * Records cannot be Deleted unless already Deactivated.
    * An audit trail of transactions will be available for some tables, and the Deactivation is necessary to keep the audit trail valid.
4. An HTML layout Framework has been coded with DIVs and CSS, using a variation of a grail (holy grail of layouts, not using grids) two/three column layout.
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
		* Developing an engine for the common features is on the future to do list.

### Future Features: ###

* Allow multiple Products to organize Assemblies and their components, so that more than one kind of estimate is available.
* An audit trail of transactions will be available for some tables, utilizing the Deactivation feature (probably using paper trail).
* Reset Password feature.
* Developing an engine for the common features between applications.
