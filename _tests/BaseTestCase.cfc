component extends="mxunit.framework.TestCase" {

	private string function getComponentType( obj ){
		if ( !IsNull( obj ) ) {
			return ListLast( GetMetaData( obj ).name, "." );
		}
		return "";
	}

	private function clearTestData(){
		lock name="clearTestData" timeout="5"  {
			var q = new Query();
			q.setSQL( "DELETE FROM AUTHOR" );
			q.execute();
		}
	}
	
	private function loadTestData(){
		lock name="loadTestData" timeout="5"  {
			clearTestData();
			
			var q = new Query();
			q.setSQL( "
				INSERT INTO AUTHOR 
				( id, forename, surname, dob )
				VALUES 
				( 1, 'John', 'Whish', '1990-04-22' ),
				( 2, 'Richard', 'Whish', '1980-04-22'  ),
				( 3, 'Fred', 'Bloggs', '1970-04-22'  ),
				( 4, 'Sam', 'Smith', '1960-04-22'  )
			" );
			q.execute();
		}
	}

}