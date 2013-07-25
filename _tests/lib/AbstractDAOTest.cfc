component extends="_tests.BaseTestCase" {

	/* ---------------------------- UNIT TESTS ---------------------------- */
	
	function init(){
		assertTrue( getComponentType( CUT ) == "AbstractDAO" );
	}

	function delete(){
		transaction{
			var result = CUT.delete( {} );
		}
		assertFalse( result );
		transaction{
			var result = CUT.delete( EntityLoadByPK( 'Author', 4 ) );
		}
		assertTrue( result );
	}
	
	function deleteByIDShouldReturnTrue(){
		transaction{
			var result = CUT.deleteByID( 4 );
		}
		assertTrue( result );
	}

	function deleteByIDShouldReturnFalse(){
		transaction{
			var result = CUT.deleteByID( -10 );
		}
		assertFalse( result );
	}

	function getByFilter(){
		transaction{
			var result = CUT.get( {surname='Whish'} );
		}
		assertTrue( IsObject(result) );
		assertEquals( 'Whish', result.getSurname() );
		
		transaction{
			var result = CUT.get( {forename='John', surname='Whish'} );
		}
		assertTrue( IsObject(result) );
		assertEquals( 'Whish', result.getSurname() );
		
		transaction{
			var result = CUT.get( {forename='John', surname='Doesnotexist'} );
		}
		assertTrue( IsNull(result) );
	}
	
	function getByBlankFilter(){
		var result = CUT.get( {} );
		assertTrue( IsObject(result) );
		assertEquals( 'Whish', result.getSurname() );
	}

	function getByFilterReturnNew(){
		var result = CUT.get( filter={forename='John', surname='Doesnotexist'}, returnnew=true );
		assertTrue( IsObject(result) );
	}

	function getBySimpleFilter(){
		var result = CUT.get( 1 );
		assertTrue( IsObject(result) );
		assertEquals( "John", result.getForename() );
		assertEquals( "Whish", result.getSurname() );
		assertEquals( 1, result.getID() );
		var result = CUT.get( 2 );
		assertTrue( IsObject(result) );
		assertEquals( "Theo", result.getForename() );
		assertEquals( "Whish", result.getSurname() );
		assertEquals( 2, result.getID() );
	}
	
	function getEntityName(){
		var result = CUT.getEntityName();
		assertEquals( "Author", result );		
	}

	function list(){
		var result = CUT.list();
		assertTrue( IsArray( result ) );		
		assertEquals( 4, ArrayLen( result ) );
	}

	function listByFilter(){
		var result = CUT.list( {surname='Whish'} );
		assertTrue( IsArray( result ) );		
		assertEquals( 2, ArrayLen( result ) );
	}
	
	function listByFilterSorted(){
		var result = CUT.list( {surname='Whish'}, 'forename' );
		assertTrue( IsArray( result ) );		
		assertEquals( 2, ArrayLen( result ) );
		assertEquals( 'John', result[1].getForename() );
		assertEquals( 'Theo', result[2].getForename() );

		var result = CUT.list( {surname='Whish'}, 'forename desc' );
		assertTrue( IsArray( result ) );		
		assertEquals( 2, ArrayLen( result ) );
		assertEquals( 'Theo', result[1].getForename() );
		assertEquals( 'John', result[2].getForename() );
	}
	
	function listByFilterSortedWithOptions(){
		var result = CUT.list( {surname='Whish'}, 'forename', {maxresults=1} );
		assertTrue( IsArray( result ) );		
		assertEquals( 1, ArrayLen( result ) );
		assertEquals( 'John', result[1].getForename() );

		var result = CUT.list( {surname='Whish'}, 'forename desc', {maxresults=1} );
		assertTrue( IsArray( result ) );		
		assertEquals( 1, ArrayLen( result ) );
		assertEquals( 'Theo', result[1].getForename() );
	}
	
	function listSorted(){
		var result = CUT.list( sortorder='surname, forename' );
		assertTrue( IsArray( result ) );		
		assertEquals( 4, ArrayLen( result ) );
		assertEquals( 'Fred', result[1].getForename() );
		assertEquals( 'Theo', result[4].getForename() );

		var result = CUT.list( sortorder='surname, forename desc' );
		assertTrue( IsArray( result ) );		
		assertEquals( 4, ArrayLen( result ) );
		assertEquals( 'Fred', result[1].getForename() );
		assertEquals( 'John', result[4].getForename() );
	}
	
	function listSortedWithOptions(){
		var result = CUT.list( sortorder='forename', options={maxresults=1} );
		assertTrue( IsArray( result ) );		
		assertEquals( 1, ArrayLen( result ) );
		assertEquals( 'Fred', result[1].getForename() );

		var result = CUT.list( sortorder='forename desc', options={maxresults=1} );
		assertTrue( IsArray( result ) );		
		assertEquals( 1, ArrayLen( result ) );
		assertEquals( 'Theo', result[1].getForename() );
	}

	function listWithOptions(){
		var result = CUT.list( options={maxresults=1} );
		assertTrue( IsArray( result ) );		
		assertEquals( 1, ArrayLen( result ) );
		assertEquals( 'John', result[1].getForename() );
	}
	
	function new(){
		var result = CUT.new();
		assertTrue( IsObject( result ) );
		assertTrue( IsNull( result.getForename() ) );
	}

	function newFromMemento(){
		var result = CUT.new( {forename='John' } );
		assertTrue( IsObject( result ) );
		assertEquals( 'John', result.getForename() );
	}

	function reload(){
		// returns void, so just check for errors
		CUT.reload( EntityLoadByPK( 'Author', 1 ) );
	}

	function save(){
		// returns void, so just check for errors
		CUT.save( EntityLoadByPK( 'Author', 1 ) );
	}

	function where(){
		var result = CUT.where( "forename='John'" );
		assertTrue( IsArray( result ) );
		assertEquals( 1, ArrayLen( result ) );

		var result = CUT.where( "surname='Whish'" );
		assertTrue( IsArray( result ) );
		assertEquals( 2, ArrayLen( result ) );

		var result = CUT.where( "surname='Whish' order by forename" );
		assertTrue( IsArray( result ) );
		assertEquals( 2, ArrayLen( result ) );
		assertEquals( 'John', result[1].getForename() );
		assertEquals( 'Theo', result[2].getForename() );

		var result = CUT.where( "surname='Whish' order by forename desc" );
		assertTrue( IsArray( result ) );
		assertEquals( 2, ArrayLen( result ) );
		assertEquals( 'Theo', result[1].getForename() );
		assertEquals( 'John', result[2].getForename() );
	}

	function whereWithParams(){
		var result = CUT.where( "forename=? and surname=?", ['John','Whish'] );
		assertTrue( IsArray( result ) );
		assertEquals( 1, ArrayLen( result ) );

		var result = CUT.where( "surname like ?", ['W%'] );
		assertTrue( IsArray( result ) );
		assertEquals( 2, ArrayLen( result ) );

		var result = CUT.where( "forename=:forename and surname=:surname", {forename='John', surname='Whish'} );
		assertTrue( IsArray( result ) );
		assertEquals( 1, ArrayLen( result ) );

		var result = CUT.where( "surname=:surname order by forename", {surname='Whish'} );
		assertTrue( IsArray( result ) );
		assertEquals( 2, ArrayLen( result ) );
		assertEquals( 'John', result[1].getForename() );
		assertEquals( 'Theo', result[2].getForename() );

		var result = CUT.where( "surname='Whish' order by forename desc" );
		assertTrue( IsArray( result ) );
		assertEquals( 2, ArrayLen( result ) );
		assertEquals( 'Theo', result[1].getForename() );
		assertEquals( 'John', result[2].getForename() );
	}
	
	function whereUnique(){
		var result = CUT.where( clause="forename=? and surname=?", params=['John','Whish'], unique=true );
		assertTrue( IsObject( result ) );
		assertEquals( 'John', result.getForename() );
		assertEquals( 'Whish', result.getSurname() );
	}

	function whereWithQueryOptions(){
		var result = CUT.where( clause="surname=?", params=['Whish'], queryOptions={maxresults=1} );
		assertTrue( IsArray( result ) );
		assertEquals( 1, ArrayLen( result ) );
		assertEquals( 'John', result[1].getForename() );
		assertEquals( 'Whish', result[1].getSurname() );
	}
	
	function executeQuery(){
		var result = CUT.executeQuery( 'from Author' );
		assertTrue( IsArray( result ) );
		assertEquals( 4, ArrayLen( result ) );
	}

	function executeQueryWithParams(){
		var result = CUT.executeQuery( 'from Author where surname=:surname order by forename', {surname='Whish'} );
		assertTrue( IsArray( result ) );
		assertEquals( 2, ArrayLen( result ) );

		var result = CUT.executeQuery( 'from Author where surname=? order by forename', ['Whish'] );
		assertTrue( IsArray( result ) );
		assertEquals( 2, ArrayLen( result ) );
	}
	
	// --- DYNAMIC METHODS -- //
	
	function deleteDynamic(){
		transaction{
			var result = CUT.deleteAuthor( EntityLoadByPK( 'Author', 4 ) );
		}
		assertTrue( result );
	}

	function getDynamic(){
		var result = CUT.getAuthor( 1 );
		assertTrue( IsObject( result ) );
		assertEquals( 'John', result.getForename() );
	}

	function listDynamic(){
		var result = CUT.listAuthor();
		assertTrue( IsArray( result ) );
		assertEquals( 4, ArrayLen( result ) );
	}

	function newDynamic(){
		var result = CUT.newAuthor();
		assertTrue( IsObject( result ) );
		assertTrue( IsNull( result.getForename() ) );
		
		var result = CUT.newAuthor( { forename='John' });
		assertTrue( IsObject( result ) );
		assertEquals( 'John', result.getForename() );
	}

	function reloadDynamic(){
		CUT.reloadAuthor( EntityLoadByPK( 'Author', 1 ) );
	}

	function saveDynamic(){
		CUT.saveAuthor( EntityLoadByPK( 'Author', 1 ) );
	}
	
	function whereDynamic(){
		var result = CUT.whereAuthor( 'surname=?', ['Whish'] );
		assertTrue( IsArray( result ) );
		assertEquals( 2, ArrayLen( result ) );
	}
	
	/* ---------------------------- IMPLICIT ---------------------------- */
	
	function beforeTests(){
	}
	
	function setUp(){
		loadTestData();
		CUT = new lib.AbstractDAO( 'Author' );
	}
	
	function tearDown(){
	}
	
	function afterTests(){
	}
	
	/* ---------------------------- HELPER ---------------------------- */
	
}