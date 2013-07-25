component extends="_tests.BaseTestCase" {

	/* ---------------------------- UNIT TESTS ---------------------------- */
	
	function init(){
		assertTrue( getComponentType( CUT ) == "DAOFactory" );
	}

	function extractEntityName(){
		makePublic( CUT, "extractEntityName" );
		assertEquals( "User", CUT.extractEntityName( "daoUser") );
		assertEquals( "User", CUT.extractEntityName( "getUser") );
		assertEquals( "User", CUT.extractEntityName( "listUser") );
		assertEquals( "User", CUT.extractEntityName( "dosomethingtoUser") );
		assertEquals( "User", CUT.extractEntityName( "doSomeThingToUser") );
	}
	
	function getVirtualDAO(){
		// user DAO does not exist so create one
		var result = CUT.getDAO( "Author" );
		assertEquals( "AbstractDAO", getComponentType( result ) ); 
		assertEquals( "Author", result.getEntityName() );
	}
	
	function getConcreteDAO(){
		// post DAO does exist so use concrete one
		var result = CUT.getDAO( "Post" );
		assertEquals( "PostDAO", getComponentType( result ) ); 
		assertEquals( "Post", result.getEntityName() );
		assertTrue( result.concreteMethod() );
	}

	function getVirtualDAODynamically(){
		// user DAO does not exist so should create one
		var result = CUT.AuthorDAO();
		assertEquals( "AbstractDAO", getComponentType( result ) ); 
		assertEquals( "Author", result.getEntityName() );
	}
	
	function getConcreteDAODynamically(){
		// post DAO does exist so use should concrete one
		var result = CUT.PostDAO();
		assertEquals( "PostDAO", getComponentType( result ) ); 
		assertEquals( "Post", result.getEntityName() );
	}
	
	function callDAOGetMethodDynamically(){
		var result = CUT.getAuthor( 1 );
		assertEquals( "Author", getComponentType( result ) );
		assertEquals( 1, result.getID() );
		var result = CUT.getAuthor( {forename="John", surname="Whish"} );
		assertEquals( "Author", getComponentType( result ) );
		assertEquals( 1, result.getID() );
	}

	function callDAOListMethodDynamically(){
		var result = CUT.listAuthor();
		assertEquals( 4, ArrayLen( result ) );
		var result = CUT.listPost();
		assertEquals( 3, ArrayLen( result ) );
	}
	
	function callDAONewMethodDynamically(){
		var result = CUT.newAuthor();
		assertEquals( "Author", getComponentType( result ) );
		var result = CUT.newPost();
		assertEquals( "Post", getComponentType( result ) );
	}

	function callDAOWhereMethodDynamically(){
		var result = CUT.whereAuthor( 'id > :id', {id=1} );
		assertEquals( 3, ArrayLen( result ) );
	}
	
	/* ---------------------------- IMPLICIT ---------------------------- */
	
	function beforeTests(){
	}
	
	function setUp(){
		loadTestData();
		
		var beanFactory = new ioc( "/model", { singletonPattern = "(Gateway|Service|Factory)$" } );
		
		CUT = new lib.DAOFactory(); 
		CUT.setBeanFactory( beanFactory );
	}
	
	function tearDown(){
	}
	
	function afterTests(){
	}
	
}