component {

	/* ---------------------------- CONSTRUCTOR ---------------------------- */  
	any function init( required entityName ){
		variables.entityName = arguments.entityName;
		return this;
	}
	
	/* ---------------------------- PUBLIC ---------------------------- */
	
	boolean function delete( param ){
		var result = false;
		if ( IsObject( arguments.param ) ){
			var Entity = arguments.param;
		}else{
			var Entity = get( arguments.param );
		}
		if ( !IsNull( Entity ) ){
			result = true;
			EntityDelete( Entity );
		}
		return result;
	}
	
	// TODO: should this match GORM?
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

	// TODO: should this match GORM?
	// Finds all of domain class instances matching the specified query
	any function findAll( required string hql, any params={}, struct queryOptions ){
		if ( StructKeyExists( arguments, "queryOptions" ) ){
			return ORMExecuteQuery( hql, params, arguments.queryOptions );
		}else{
			return ORMExecuteQuery( hql, params );
		}
	}
	
	// Retrieves an instance of the domain class for the specified id. 
	// null is returned if the row with the specified id doesn't exist.
	any function get( id ){
		return EntityLoadByPK( variables.entityName, arguments.id );
	}
	 
	// Retrieves a List of instances of the domain class for the specified ids, ordered by the original ids list.
	// If some of the provided ids are null or there are no instances with these ids, the resulting List will 
	// have null values in those positions.
	array function getAll( array ids ){
		var hql = ' from ' & variables.entityName & ' ';
		if ( StructKeyExists( arguments, "ids" ) ){
			hql &= ' where id in ( :list ) ';
			return ORMExecuteQuery( hql, { list=arguments.ids } );
		}else{
			return ORMExecuteQuery( hql, [] );
		}
	}
	
	array function list( string sort, string order, numeric offset, numeric max  ){
		var hql = ' from ' & variables.entityName & ' ';
		var queryOptions = {};
		if ( StructKeyExists( arguments, "offset" ) ){
			queryOptions.offset = arguments.offset;
		}
		if ( StructKeyExists( arguments, "max" ) ){
			queryOptions.maxresults = arguments.max;
		}
		if ( StructKeyExists( arguments, "sort" ) ){
			param name="arguments.order" default="";
			arguments.sort &= ' ' & arguments.order;
			return queryBuilder( filtercriteria={}, sortorder=arguments.sort, queryOptions=queryOptions );
		}else{
			return queryBuilder( queryOptions=queryOptions );
		}
	}

	any function new(){
		return EntityNew( variables.entityName );
	}
	
	void function save( Entity ){
		EntitySave( arguments.Entity );
	}
	
	
	/* ---------------------------- PRIVATE ---------------------------- */  
	
	private any function queryBuilder( struct filtercriteria, string sortorder, struct queryOptions, boolean likeQuery, boolean betweenQuery ){
		var hql = ' from ' & variables.entityName & ' ';
		var params = {};
		var result = [];
		var hasWhereClause = false;
		
		param name="arguments.likeQuery" default="false"; 
		
		if ( StructKeyExists( arguments, "filtercriteria" ) && StructCount( arguments.filtercriteria ) ) {
			for ( var key in arguments.filtercriteria ){
				if ( !hasWhereClause ){
					hql &= ' where ';
					hasWhereClause = true;
				}else{
					hql &= ' and ';
				}
				if ( IsArray( arguments.filtercriteria[ key ] ) ){ // between
					hql &= LCase( key ) & ' BETWEEN :#key#_1 AND :#key#_2 ';
					params[ key & "_1" ] = arguments.filtercriteria[ key ][ 1 ];
					params[ key & "_2" ] = arguments.filtercriteria[ key ][ 2 ];
				}else{
					if ( arguments.likeQuery ){
						hql &= LCase( key ) & ' LIKE :#key# ';
					}else{
						hql &= LCase( key ) & ' = :#key# ';
					}
					params[ key ] = arguments.filtercriteria[ key ];
				}
				//ArrayAppend( params, arguments.filtercriteria[ key ] );
			}
		}
		
		if ( StructKeyExists( arguments, "sortorder" ) ) {
			hql &= 'order by ' & arguments.sortorder;
		}
//request.debug([hql,params,arguments]);
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
			var likeQuery = ReFind( "Like$", arguments.missingMethodName ) != 0;
			var betweenQuery = ReFind( "Between$", arguments.missingMethodName ) != 0;
			for ( var i=1; i<= ArrayLen( properties ); i++ ){
				if ( betweenQuery ){
					properties[ i ] = ReReplace( properties[ i ], "Between$", "" );
					filtercriteria[ properties[ i ] ] = [ missingMethodArguments[ i ], missingMethodArguments[ i+1 ] ];
				}else{
					if ( likeQuery ){
						properties[ i ] = ReReplace( properties[ i ], "Like$", "" );
					}
					filtercriteria[ properties[ i ] ] = missingMethodArguments[ i ];
				}
			}
			if ( ReFind( "^findAllBy", arguments.missingMethodName ) ){
				return queryBuilder( filtercriteria=filtercriteria, likeQuery=likeQuery );
			}else{
				// should only return one
				var result = queryBuilder( filtercriteria=filtercriteria, queryOptions={maxresults=1}, likeQuery=likeQuery );
				if ( ArrayLen( result ) == 1 ) {
					return result[ 1 ];
				}
			}
		}
	}
	
}