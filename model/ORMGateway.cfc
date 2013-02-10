/*
* Rails Methods:
*	find( id ) - returns single entity if found else null
*	find( [ids] ) - returns array of entity where id in array
*	where( "id > :id and active = :active", {id=1, active=true} ) - returns array of entities where id in array
*/
component {

	/* ---------------------------- CONSTRUCTOR ---------------------------- */  
	any function init(){
		variables.entitygateway = {};
		return this;
	}
	
	/* ---------------------------- PUBLIC ---------------------------- */
	
	boolean function delete( required any arg ){
		if ( IsObject( arguments.arg ) ){
			EntityDelete( arguments.arg );
			return true;
		}
		return false;
	}

	boolean function deleteByID( required string entityname, required id ){
		var entity = get( arguments.entityname, arguments.id );
		var result = false;
		if ( !IsNull( entity ) ){
			result = delete( entity );
		}
		return result;
	}

	any function get( required string entityname, required any filter, boolean returnnew=false ){
		if ( IsSimpleValue( arguments.filter ) ){
			var result = EntityLoadByPK( arguments.entityname, arguments.filter );
		}else{
			var matches = EntityLoad( arguments.entityname, arguments.filter, {maxresults=1} );
			if ( ArrayLen( matches ) == 1 ){
				var result = matches[ 1 ];
			}
		}
		if ( arguments.returnnew && IsNull( result ) ){
			return new( arguments.entityname );
		}
		if ( !IsNull( result ) ){
			return result;
		}
	}
	
	array function list( required string entityname, struct filter={} ){
		return EntityLoad( arguments.entityName, arguments.filter );
	}
	
	any function new( required string entityname, struct memento={} ){
		return EntityNew( arguments.entityName );
	}
	
	array function where( required string entityname, required string clause, struct params={} ){
		var hql = 'from ' & arguments.entityname & ' where ' & arguments.clause;
		return ORMExecuteQuery( hql, arguments.params );
	}
	
	/*
	* supports:
	* getEntity( id ) - returns object by id or null
	* getEntity( {} ) - returns object by filter or null
	* getEntity( id, true ) - returns object by id or new object
	* getEntity( {}, true ) - returns object by filter or new object
	* listEntity() - returns array of objects
	* listEntity( {} ) - returns array of objects by filter
	* listEntityByProperty( value )
	* deleteEntity( id )
	* deleteEntity( object )
	* saveEntity( object )
	*/
	any function onMissingMethod( required String missingMethodName, required struct missingMethodArguments ){
		var args = {
			entityname = extractEntityName( arguments.missingMethodName )
		};
		if ( arguments.missingMethodName.startsWith( "delete" ) ){
			args.id = arguments.missingMethodArguments[ 1 ];
			return deleteByID( argumentCollection=args );
		}
		else if ( arguments.missingMethodName.startsWith( "get" ) ){
			args.filter = arguments.missingMethodArguments[ 1 ];
			if ( ArrayIsDefined( arguments.missingMethodArguments, 2 ) ){
				args.returnnew = arguments.missingMethodArguments[ 2 ]; 
			}
			return get( argumentCollection=args );
		}else if ( arguments.missingMethodName.startsWith( "list" ) ){
			if ( ArrayIsDefined( arguments.missingMethodArguments, 1 ) ){
				args.filter = arguments.missingMethodArguments[ 1 ]; 
			}
			return list( argumentCollection=args );
		}else if ( arguments.missingMethodName.startsWith( "new" ) ){
			return new( args.entityname );
		}
	}

	/* ---------------------------- PRIVATE ---------------------------- */
	
	private string function extractEntityName( required string value ){
		var result = ReReplace( arguments.value, "^(delete|get|list|new|save)", "" );
		var index = Find( "By", result, 2 ); // note: case sensitive
		if ( index == 0 ){
			return result;
		}
		return Left( result, index-1 );
	}
	
	private any function getEntityGateway( required string entityname ){
		lock name="getEntityGateway_#arguments.entityname#" timeout="15"{ 
			if ( !StructKeyExists( variables.entitygateway, arguments.entityname ) ){
				variables.entitygateway[ arguments.entityname ] = new AbstractGateway( arguments.entityname );
			}
		}
		return variables.entitygateway[ arguments.entityname ];
	}
	
}