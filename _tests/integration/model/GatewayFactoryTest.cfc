component extends="mxunit.framework.TestCase" {

	/* ---------------------------- UNIT TESTS ---------------------------- */
	
	function init(){
		var result = CUT.init();
		assertTrue( ListLast( GetMetaData( result ).name, "." ) == "GatewayFactory" );
	}

	function getGateway(){
		assertFalse( CUT.hasGateway( "Author" ) );
		var result = CUT.getGateway( "Author" );
		assertTrue( ListLast( GetMetaData( result ).name, "." ) == "AbstractGateway" );
		assertTrue( CUT.hasGateway( "Author" ) );
	}

	function hasGateway(){
		assertFalse( CUT.hasGateway( "Author" ) );
		injectProperty( CUT, "Author", "abc123", "gateways" );
		assertTrue( CUT.hasGateway( "Author" ) );
	}
	
	/* ---------------------------- IMPLICIT ---------------------------- */
	
	function beforeTests(){
	}
	function setUp(){
		CUT = new model.GatewayFactory(); 
	}
	function tearDown(){
	}
	function afterTests(){
	}
	
}