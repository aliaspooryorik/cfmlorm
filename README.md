cfmlorm
======================================================================

An experiment to see if can replicate GORM features in CFML. 
**This is not for use in production (yet)!**

If you're interested in this approach have a look at:
http://sourceforge.net/apps/trac/coldspring/wiki/ORMAbstractGateway

Usage
----------------------------------------------------------------------

	// initiate
	Gateway # new model.AbstractGateway( 'Author' );

	// returns new
	writeDump( Gateway.new() );

	// returns an array of Author entities
	writeDump( Gateway.list();
	
	// returns an array of Author entities matching passed ids
	writeDump( Gateway.getAll( [1,3] );

	// returns an array of Author entities
	writeDump( Gateway.findAllByForenameAndSurname( 'John', 'Whish' );

	// returns 1st match as an Author object
	writeDump( Gateway.findByForenameAndSurname( 'John', 'Whish' );
	
	// returns Author object or null
	writeDump( Gateway.get( 1 );
	
	// returns a boolean if Author deleted
	writeDump( Gateway.delete( 1 );
	
	// saves Entity
	writeDump( Gateway.save( object );

Methods
----------------------------------------------------------------------

### delete : Boolean

	BookGateway.delete(1);
	BookGateway.delete( Entity );

### find : Entity
	// Dan brown's first BookGateway
	BookGateway.find("from BookGateway as b where b.author#'Dan Brown'");
	// with a positional parameter
	BookGateway.find("from BookGateway as b where b.author#?", ['Dan Brown']);

	// with a named parameter
	BookGateway.find("from BookGateway as b where b.author#:author", {author: 'Dan Brown'});
	
### findBy* : Entity

	BookGateway.findByTitleAndAuthor("The Sum of All Fears", "Tom Clancy");
	
### findAllBy* : Array

	BookGateway.findAllByTitleAndAuthor("The Sum of All Fears", "Tom Clancy");

### get : Entity

	BookGateway.get(1);
	
### getAll : Array

	BookGateway.getAll("1,2,3");
	BookGateway.getAll();
	
### list : Array

	BookGateway.list();
	BookGateway.list( sort="title" );
	BookGateway.list( sort="title", order="desc" );
	
Non GORM stuff
----------------------------------------------------------------------

### new

	BookGateway.new();

### save

	BookGateway.save( Book );