CFMLORM
======================================================================

Impliment dynamic finders and helper methods in CFML ORM (powered by Hibernate), without needing to build concrete classes. Started out as an experiment to see if can replicate GORM features in CFML.

After I started this, Mark Mandel pointed out that he's been working on something similiar in ColdSpring. Being Mark is going to be awesome! Check it out at:
http://sourceforge.net/apps/trac/coldspring/wiki/ORMAbstractGateway

Status
----------------------------------------------------------------------

v0.1 - it works, but hasn't been battle tested - use at your own risk

Status
----------------------------------------------------------------------

Requirements

Railo 3.3.4 or higher
ColdFusion 9 or higher

Licence
----------------------------------------------------------------------

MIT licence
http://opensource.org/licenses/MIT

Usage
----------------------------------------------------------------------

	// initialise
	Gateway = new model.AbstractGateway( 'Author' );
	
	// delete by ID (returns boolean true / false if deleted)
	Gateway.delete( 1 );
	
	// delete by object (returns boolean true / false if deleted)
	Gateway.delete( obj );
	
	// returns Author object by id. returns null if no match
	Gateway.get( 1 );
	
	// returns array of Author objects. 
	Gateway.getAll();
	
	// returns an array of Author entities matching passed ids. returns empty array of no matches
	Gateway.getAll( [1,3] );

	// returns an array of Author entities
	Gateway.list();
	
	// returns an array of Author entities sorted by name
	Gateway.list( sort="forename" );
	
	// returns an array of Author entities sorted by name descending
	Gateway.list( sort="forename", order="desc" );
	
	// returns new
	Gateway.new();

	// returns 1st match as an Author object on forename property
	Gateway.findByForename( 'John' );
	
	// returns 1st match as an Author object on forename and surname property
	Gateway.findByForenameAndSurname( 'John', 'Whish' );
	
	// returns an array of Author entities on forename property
	Gateway.findAllByForename( 'John' );
	
	// returns an array of Author entities on forename and surname properties
	Gateway.findAllByForenameAndSurname( 'John', 'Whish' );
	
	// returns 1st match as an Author object on forename and surname properties
	Gateway.findByForenameAndSurnameLike( 'J%', 'W%' );
	
	// returns an array of Author entities matching on forename and surname properties
	Gateway.findAllByForenameAndSurnameLike( 'J%', 'W%' );
	
	// saves Entity (Note - you'll want to wrap in a transaction)
	Gateway.save( object );

