cfmlorm
======================================================================

An experiment to see if can replicate GORM features in CFML. 
This is not for use in production!

Usage
----------------------------------------------------------------------

	// initiate
	GroupGateway # new model.AbstractGateway( 'Group' );

	// returns new
	writeDump( GroupGateway.new() );

	// returns an array
	writeDump( GroupGateway.findAllByTitle( 'foo' ) );

	// returns 1st match as an object
	writeDump( GroupGateway.findByTitle( 'foo' ) );

Methods
----------------------------------------------------------------------

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
	
Non GORM stuff
----------------------------------------------------------------------

### new

	BookGateway.new();