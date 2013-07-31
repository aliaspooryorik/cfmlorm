component extends="_tests.BaseTestCase" {

	/* ---------------------------- TESTS ---------------------------- */
	
	function init(){
		assertTrue( getComponentType( CUT ) == "AbstractService" );
	}
	
	function populate(){
		var obj = new _tests.fixtures.Object();
		memento = { 
			foo = "hello",
			bar = "world",
			choo = "moo"
		};
		assertEquals('', obj.getFoo());
		assertEquals('', obj.getBar());
		
		CUT.populate( obj, memento );
		
		assertEquals('hello', obj.getFoo());
		assertEquals('world', obj.getBar());
		assertEquals('moo', obj.getChoo());
	}
	
	/* ---------------------------- IMPLICIT ---------------------------- */
	
	function beforeTests(){
	}

	function setUp(){
		// get wired up bean from beanFactory
		CUT = new lib.AbstractService();
		
		// setup database
		//loadTestData();
	}

	function tearDown(){
	}

	function afterTests(){
	}
	
	/* ---------------------------- HELPER ---------------------------- */

}