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

			q.setSQL( "DELETE FROM POST" );
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
				( 2, 'Theo', 'Whish', '1980-04-22' ),
				( 3, 'Fred', 'Bloggs', '1970-04-22' ),
				( 4, 'Sam', 'Smith', '1960-04-22' )
			" );
			q.execute();

			q.setSQL( "
				INSERT INTO POST 
				( id, title, description, published, fk_author_id )
				VALUES 
				(1, 'Post A', 'Example post A', '1', 1),
				(2, 'Post B', 'Example post B', '1', 1),
				(3, 'Post C', 'Example post C', '1', 1)
			" );
			q.execute();

		}
	}

}