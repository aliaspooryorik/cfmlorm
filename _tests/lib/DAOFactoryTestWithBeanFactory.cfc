component extends="DAOFactoryTest" {

	/* ---------------------------- UNIT TESTS ---------------------------- */
	
	function getConcreteDAO(){
		// post DAO does exist so use concrete one
		var result = CUT.getDAO( "Post" );
		assertEquals( "PostDAO", getComponentType( result ) ); 
		assertEquals( "Post", result.getEntityName() );
		assertTrue( result.concreteMethod() );
	}

	function getConcreteDAODynamically(){
		// post DAO does exist so use should concrete one
		var result = CUT.PostDAO();
		assertEquals( "PostDAO", getComponentType( result ) ); 
		assertEquals( "Post", result.getEntityName() );
	}
	
	/* ---------------------------- IMPLICIT ---------------------------- */
	
	function beforeTests(){
	}
	
	function setUp(){
		loadTestData();
		
		var beanFactory = new ioc( "/model", { singletonPattern = ".+(DAO)$" } );
		
		CUT = new lib.DAOFactory(); 
		CUT.setBeanFactory( beanFactory );
	}
	
	function tearDown(){
	}
	
	function afterTests(){
	}
	
}