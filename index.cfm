<cfscript>
	
// initiate
GroupGateway = new model.AbstractGateway( 'Group' );

// returns new
writeDump( GroupGateway.new() );

// returns an array
writeDump( GroupGateway.findAllByTitle( 'foo' ) );

// returns 1st match as an object
writeDump( GroupGateway.findByTitle( 'foo' ) );
</cfscript>
