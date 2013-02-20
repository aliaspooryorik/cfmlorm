CFMLORM
======================================================================

Implement dynamic finders and helper methods in CFML ORM (powered by Hibernate), without 
needing to build concrete classes.  

The aim is to build something with no dependencies that can be used with a beanFactory or 
standalone.

If you are using concrete DAOs, then it is recommended that you use a BeanFactory (the tests use DI/1)

After I started this, Mark Mandel pointed out that he's been working on something similar in 
ColdSpring. Being Mark it is going to be awesome! Check it out at:
http://sourceforge.net/apps/trac/coldspring/wiki/ORMAbstractGateway
https://github.com/markmandel/coldspring/blob/develop/coldspring/orm/hibernate/AbstractGateway.cfc

The ColdBox team have an impressive and comprehensive ORM Service layer:
http://wiki.coldbox.org/wiki/Extras:BaseORMService.cfm
https://github.com/ColdBox/coldbox-platform/blob/master/system/orm/hibernate/BaseORMService.cfc

Status
----------------------------------------------------------------------

v0.6
	it works, but hasn't been battle tested. Subject to API changes 
	Use at your own risk :)

Status
----------------------------------------------------------------------

Requirements

Railo 3.3.4 or higher
ColdFusion 9 or higher


Usage
----------------------------------------------------------------------

### Concept

The idea behind this project is that you can use the AbstractDAO as an abstract
class for you concrete DAOs to extend. However, I often find (particularly during 
the early prototyping stages) that my concrete classes just extend the AbstractDAO 
and have no methods of their own. With this in mind, the AbstractDAO has been designed 
so that virtual DAOs can be created on the fly.

### Creating Virtual DAOs

If you want to create a virtual DAO then simply pass in the entity name

	// create a virtual DAO for the Author entity
	AuthorDAO = new AbstractDAO( 'Author' );
	
### Creating Concrete DAOs

If you want to extend the AbstractDAO with your own concrete DAOs then your
DAO would need to be instantiated like so:

	component extends="model.abstract.AbstractDAO" {
	
		/* CONSTRUCTOR 
		----------------------------------------------------------------- */
		  
		any function init(){
			return super.init( 'Author' );
		}
		
		/* YOUR METHODS HERE 
		----------------------------------------------------------------- */
		
	}

## Using ColdSpring to create Virtual DAOs

If you're are using ColdSpring then you could choose to have ColdSpring create and manage
your virtual instances. An example config would be:

	<bean id="SomethingDAO" class="model.AbstractDAO">
		<constructor-arg name="entityName">
			<value>Something</value>
		</constructor-arg>
	</bean>

### Virtual DAO Calls using the DAOFactory

the DAOFactory.cfc allows you to call methods in DAOs, the DAOFactory.cfc will either 
create a virtual one of use the concrete one. It allow allows you to use some nice 
syntactical sugar.

Please note that if you have concrete classes then you will need to use a beanFactory as 
the DAOFactory will get the concrete instance from the beanFactory. The DAOFactory will not
search your file system!

	DAO = new DAOFactory();
	
	/*
	Note: The DAO looks for the last part of the method name to determine which DAO
	to use. In the following examples the UserDAO.cfc will be used
	*/
	
	// get a User by ID
	DAO.getUser( 1 );
	
	// get new User
	DAO.newUser();
	
	// list Users
	DAO.listUser();
	
The advantage of this approach is that you can start off using the virtual DAO and the switch 
to a concrete DAO seamlessly in your application at a later date. 

If you just want to get a reference to the DAO you can simple do:

	DAO = new DAOFactory();
	UserDAO = DAO.UserDAO();
	
Once you have a reference to the UserDAO then you can call the methods directly if you 
don't want to take advantage of onMissingMethod.

	DAO = new DAOFactory();
	UserDAO = DAO.getDAO( "User" );
	
	// get a User by ID
	UserDAO.get( 1 );
	
	// get new User
	UserDAO.new();
	
	// list Users
	UserDAO.list();

The choice is yours!

### Methods

These are the methods you can call on the virtual / concrete DAO. I need to document these a bit better :)

	// get one by id. returns null if no match
	get( id )
	
	// get one by filter. returns null if no match
	get( {} )
	
	// get one by id. returns new if no match
	get( id, true )
	
	// get one by filter. returns new if no match
	get( {}, true )
	
	// delete by id
	deleteByID( id )
	
	// delete by passed entity
	delete( obj )
	
	// returns the entity the DAO is managing
	getEntityName()
	
	// returns arrays
	list()
	list( struct filter )
	list( struct filter, string sortorder )
	list( struct filter, string sortorder, struct options )
	
	// new
	new()
	new( struct memento ) // note: requires Railo 4 or ColdFusion 10
	
	// save
	save( obj )
	
	// where
	where( string clause, struct params )
	where( string clause, array params )
	
	// where examples:
	where( "id > :id and active = :active", {id=1,active=true})
	where( "surname like ? order by forename", ['W%'])
	
	// executeQuery
	executeQuery( required hql, params={}, unique=false, queryOptions={} )
	
	
Licence
----------------------------------------------------------------------

   Copyright 2013 John Whish

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
