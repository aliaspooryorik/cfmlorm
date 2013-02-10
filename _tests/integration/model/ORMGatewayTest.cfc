component extends="_tests.BaseTestCase" {

	/* ---------------------------- UNIT TESTS ---------------------------- */
	
	function init(){
		var result = CUT.init();
		assertTrue( getComponentType( result ) == "ORMGateway" );
	}

	/**
	* @mxunit:dataprovider methodnames
	*/
	function extractEntityName( methodname ){
		makePublic( CUT, "extractEntityName" );
		// Note: testing against Byte as contains "By"
		assertEquals( "Byte", CUT.extractEntityName( methodname ) );
	}
	
	// delete
	
	function deleteShouldReturnTrue(){
		var result = CUT.delete( EntityLoadByPK( "Author", 1 ) );
		assertEquals( true, result );
	}
	
	function deleteByIDShouldReturnFalse(){
		var result = CUT.deleteByID( "Author", -1 );
		assertEquals( false, result );
	}
	
	function deleteByIDShouldReturnTrue(){
		var result = CUT.deleteByID( "Author", 1 );
		assertEquals( true, result );
	}
	
	// dynamic delete
	
	function deleteAuthorShouldReturnFalse(){
		var result = CUT.deleteAuthor( -1 );
		assertEquals( false, result );
	}

	function deleteAuthorShouldReturnTrue(){
		var result = CUT.deleteAuthor( 1 );
		assertEquals( true, result );
	}
	
	// get
	
	function getSimpleShouldReturnAuthor(){
		var result = CUT.get( "Author", 1 );
		assertEquals( "Author", getComponentType( result ) );
		assertEquals( 1, result.getID() );
	}
	
	function getSimpleShouldReturnNull(){
		var result = CUT.get( "Author", -1 );
		assertTrue( IsNull( result ) );
	}

	function getSimpleShouldReturnAuthorIfReturnNew(){
		var result = CUT.get( "Author", -1, true );
		assertEquals( "Author", getComponentType( result ) );
		assertTrue( IsNull( result.getID() ) );
	}

	function getFilterShouldReturnAuthor(){
		var result = CUT.get( "Author", {forename='John'} );
		assertEquals( "Author", getComponentType( result ) );
		assertEquals( 1, result.getID() );
	}
	
	// dynamic get

	function dynamicGetSimpleShouldReturnAuthor(){
		var result = CUT.getAuthor( 1 );
		assertEquals( "Author", getComponentType( result ) );
		assertEquals( 1, result.getID() );
	}
	
	function dynamicGetSimpleShouldReturnNull(){
		var result = CUT.getAuthor( -1 );
		assertTrue( IsNull( result ) );
	}

	function dynamicGetSimpleShouldReturnAuthorIfReturnNew(){
		var result = CUT.getAuthor( -1, true );
		assertEquals( "Author", getComponentType( result ) );
		assertTrue( IsNull( result.getID() ) );
	}

	function dynamicGetFilterShouldReturnAuthor(){
		var result = CUT.getAuthor( {forename='John',surname='Whish'} );
		assertEquals( "Author", getComponentType( result ) );
		assertEquals( 1, result.getID() );
	}
	
	// new 
	
	function newShouldReturnAuthor(){
		var result = CUT.new( "Author" );
		assertEquals( "Author", getComponentType( result ) );
		assertTrue( IsNull( result.getID() ) );
	}

	// dynamic new 
	
	function dynamicnewShouldReturnAuthor(){
		var result = CUT.newAuthor();
		assertEquals( "Author", getComponentType( result ) );
		assertTrue( IsNull( result.getID() ) );
	}
	
	// list
	
	function listShouldReturnAll(){
		var result = CUT.list( 'Author' );
		assertEquals( 4, ArrayLen( result ) );
	}
	
	// dynamic list
	
	function dynamiclistShouldReturnAll(){
		var result = CUT.listAuthor();
		assertEquals( 4, ArrayLen( result ) );
	}	

	// where 
	
	function whereShouldReturnArray(){
		var arg = {id=1};
		var result = CUT.where( 'Author', 'id > :id and surname like :surname order by forename desc', {id=0, surname="W%" } );
		assertEquals( 2, ArrayLen( result ) );
	}


	/* ---------------------------- IMPLICIT ---------------------------- */
	
	function beforeTests(){
	}
	function setUp(){
		CUT = new model.ORMGateway();
		methodnames = "getByte,getByteByForename,listByte,listByteByForename,deleteByte,saveByte,newByte";
		
		loadTestData();
	}
	function tearDown(){
		clearTestData();
	}
	function afterTests(){
	}
	
}