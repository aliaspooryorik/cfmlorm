component {

	/* ---------------------------- CONSTRUCTOR ---------------------------- */  
	function init( required entityName ){
		variables.entityName = arguments.entityName;
		return this;
	}
	
	/* ---------------------------- PUBLIC ---------------------------- */  
	
	// Finds the first matching result for the given query or null if no instance is found
	any function find( required string hql, any params, struct queryOptions ){
		var result = [];
		//param name="arguments.queryOptions" default="#StructNew()#";
		arguments.queryOptions.maxresults = 1;
		result = findAll( arguments.hql, arguments.params, arguments.queryOptions );
		if ( ArrayLen( result ) == 1 ){
			return result;
		}
	}

	// Finds all of domain class instances matching the specified query
	any function findAll( required string hql, any params={}, struct queryOptions ){
		if ( StructKeyExists( arguments, "queryOptions" ) ){
			return ORMExecuteQuery( hql, params, arguments.queryOptions );
		}else{
			return ORMExecuteQuery( hql, params );
		}
	}



	any function new(){
		return EntityNew( variables.entityName );
	}
	

	
	
	/* ---------------------------- PRIVATE ---------------------------- */  
	
	private any function queryBuilder( struct filtercriteria, string sortorder, struct queryOptions ){
		var hql = ' from ' & variables.entityName & ' ';
		var params = {};
		var result = [];
		
		if ( StructKeyExists( arguments, "filtercriteria" ) && StructCount( arguments.filtercriteria ) ) {
			hql &= ' where ';
			for ( var key in arguments.filtercriteria ){
				hql &= LCase( key ) & ' = :#key# ';
				params[ key ] = arguments.filtercriteria[ key ];
				//ArrayAppend( params, arguments.filtercriteria[ key ] );
			}
		}
		
		if ( StructKeyExists( arguments, "sortorder" ) ) {
			hql &= 'order by ' & arguments.sortorder;
		}
		
		if ( StructKeyExists( arguments, "queryOptions" ) ) {
			return ORMExecuteQuery( hql, params, arguments.queryOptions );
		} else {
			return ORMExecuteQuery( hql, params );
		}
	}
	
	
	/* ---------------------------- IMPLICIT ---------------------------- */  
	
	function onMissingMethod( string missingMethodName, struct missingMethodArguments ){
		if ( ReFind( "^find(All)?By", arguments.missingMethodName ) ){
			var properties = ListToArray( Replace( ReReplace( arguments.missingMethodName, "^find(All)?By", "" ), "And", "|" ), "|" );
			var filtercriteria = {};
			for ( var i=1; i<= ArrayLen( properties ); i++ ){
				filtercriteria[ properties[ i ] ] = missingMethodArguments[ i ];
			}
			if ( ReFind( "^findAllBy", arguments.missingMethodName ) ){
				return queryBuilder( filtercriteria=filtercriteria );
			}else{
				// should only return one
				var result = queryBuilder( filtercriteria=filtercriteria, queryOptions={maxresults=1} );
				if ( ArrayLen( result ) == 1 ) {
					return result[ 1 ];
				}
			}
		}
	}
	
}