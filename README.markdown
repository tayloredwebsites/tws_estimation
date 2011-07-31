# Authorization and Authentication by Application and Roles startup application

This is a startup application by [Taylored Web Sites](http://www.tayloredwebsites.com).

Authorization will be provided by using the users table (using active record).

Authentication will allow the application to control access to actions based upon the user's rights (multiple roles can be assigned to a user).  For performance purposes, roles are stored in a single string field in the users table.  Uses the  [CanCan](https://github.com/ryanb/cancan) authorization library.
