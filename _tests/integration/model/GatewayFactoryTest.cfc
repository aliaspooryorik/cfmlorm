component extends="mxunit.framework.TestCase" {

	/* ---------------------------- UNIT TESTS ---------------------------- */
	
	function init(){
		assertTrue( IsInstanceOf( CUT.init(), "GatewayFactory" ) );
	}

	function getGateway(){
		assertFalse( CUT.hasGateway( "foobar" ) );
		assertTrue( IsInstanceOf( CUT.getGateway( "foobar" ), "AbstractGateway" ) );
		assertTrue( CUT.hasGateway( "foobar" ) );
	}

	function hasGateway(){
		assertFalse( CUT.hasGateway( "foobar" ) );
		injectProperty( CUT, "foobar", "abc123", "gateways" );
		assertTrue( CUT.hasGateway( "foobar" ) );
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