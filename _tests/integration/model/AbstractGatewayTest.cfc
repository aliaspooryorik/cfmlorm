component extends="mxunit.framework.TestCase" {

	/* ---------------------------- UNIT TESTS ---------------------------- */
	
	function init(){
		assertTrue( getComponentType( CUT ) == "AbstractGateway" );
	}
	
	function delete(){
		var result = CUT.getAll();
		assertTrue( ArrayLen( result ) == 3 );
		transaction{
			var result = CUT.delete( 9999 );
		}
		assertFalse( result );
		transaction {
			var result = CUT.delete( 1 );
		}
		var result = CUT.getAll();
		assertTrue( ArrayLen( result ) == 2 );
		transaction{
			var result = CUT.delete( EntityLoadByPK( "Author", 2 ) );
		}
		var result = CUT.getAll();
		assertTrue( ArrayLen( result ) == 1 );
	}
	
	function get(){
		assertTrue( IsNull( CUT.get( 9999 ) ) );
		var result = CUT.get( 1 );
		assertTrue( !IsNull( result ) );
		assertTrue( getComponentType( result ) == "Author" );
		assertEquals( 1, result.getID() );
	}
	
	function getAll(){
		var result = CUT.getAll();
		assertTrue( IsArray( result ) );
		assertTrue( ArrayLen( result ) == 3 );
		var result = CUT.getAll( [1,3] );
		assertTrue( IsArray( result ) );
		assertTrue( ArrayLen( result ) == 2 );
		var result = CUT.getAll( [2] );
		assertTrue( IsArray( result ) );
		assertTrue( ArrayLen( result ) == 1 );
		assertTrue( result[ 1 ].getID() == 2 );
		var result = CUT.getAll( [9999] );
		assertTrue( IsArray( result ) );
		assertTrue( ArrayLen( result ) == 0 );
	}

	function list(){
		var result = CUT.list();
		assertTrue( IsArray( result ) );
		assertTrue( ArrayLen( result ) == 3 );
		var resultAsc = CUT.list( sort="forename" );
		var resultDesc = CUT.list( sort="forename", order="desc" );
		assertTrue( IsArray( resultAsc ) );
		assertTrue( IsArray( resultDesc ) );
		assertTrue( ArrayLen( resultAsc ) == 3 );
		assertTrue( ArrayLen( resultDesc ) == 3 );
		assertTrue( resultAsc[ 3 ].getID() == resultDesc[ 1 ].getID() );
	}
	
	function new(){
		var result = CUT.new();
		assertTrue( getComponentType( result ) == "Author" );
	}
	
	/* -- dynamic methods using onMissingMethod -- */
	function findBy(){
		var result = CUT.findByForename( 'John' );
		assertTrue( getComponentType( result ) == "Author" );
		var result = CUT.findByForenameAndSurname( 'John', 'Whish' );
		assertTrue( getComponentType( result ) == "Author" );
		assertTrue( result.getForename() == "John" );
		assertTrue( result.getSurname() == "Whish" );
	}
	function findAllBy(){
		var result = CUT.findAllBySurname( 'Whish' );
		assertTrue( IsArray( result ) );
		assertTrue( ArrayLen( result ) == 2 );
		var result = CUT.findAllByForenameAndSurname( 'John', 'Whish' );
		assertTrue( IsArray( result ) );
		assertTrue( ArrayLen( result ) == 1 );
	}
	
	/* ---------------------------- IMPLICIT ---------------------------- */
	
	function beforeTests(){
	}
	function setUp(){

		var q = new Query();
		q.setSQL( "
			INSERT INTO AUTHOR 
			( id, forename, surname )
			VALUES 
			( 1, 'John', 'Whish' ),
			( 2, 'Richard', 'Whish' ),
			( 3, 'Fred', 'Bloggs' )
		" );
		q.execute();
		
		CUT = new model.AbstractGateway( 'Author' ); 
	}
	function tearDown(){
		var q = new Query();
		q.setSQL( "DELETE FROM AUTHOR" );
		q.execute();
	}
	function afterTests(){
	}
	
	
	/* ---------------------------- HELPER ---------------------------- */
	private string function getComponentType( obj ){
		if ( !IsNull( obj ) ) {
			return ListLast( GetMetaData( obj ).name, "." );
		}
		return "";
	}
	
}