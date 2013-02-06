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

	any function new( struct memento ){
		// Note: in CF10+ & Railo 3.3+ EntityNew( name, memento ) is supported
		var result = EntityNew( variables.entityName );
		if ( StructKeyExists( arguments, "memento" ) ){
			populate( result, arguments.memento );
		}
		return result;
	}
	
	/*
	populate method is a modified version of https://github.com/seancorfield/fw1/blob/master/org/corfield/framework.cfc
	
	Copyright (c) 2009-2012, Sean Corfield, Ryan Cogswell

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
	*/
	public any function populate( any cfc, struct memento, string keys = '', boolean trustKeys = false, boolean trim = false, deep = false ) {
		if ( keys == '' ) {
			if ( trustKeys ) {
				// assume everything in the request context can be set into the CFC
				for ( var property in memento ) {
					try {
						var args = { };
						args[ property ] = memento[ property ];
						if ( trim && isSimpleValue( args[ property ] ) ) args[ property ] = trim( args[ property ] );
						// cfc[ 'set'&property ]( argumentCollection = args ); // ugh! no portable script version of this?!?!						
						setProperty( cfc, property, args );
					} catch ( any e ) {
						onPopulateError( cfc, property, memento );
					}
				}
			} else {
				var setters = findImplicitAndExplicitSetters( cfc );
				for ( var property in setters ) {
					if ( structKeyExists( memento, property ) ) {
						var args = { };
						args[ property ] = memento[ property ];
						if ( trim && isSimpleValue( args[ property ] ) ) args[ property ] = trim( args[ property ] );
						// cfc[ 'set'&property ]( argumentCollection = args ); // ugh! no portable script version of this?!?!
						setProperty( cfc, property, args );
					} else if ( deep && structKeyExists( cfc, 'get' & property ) ) {
						//look for a context property that starts with the property
						for ( var key in memento ) {
							if ( listFindNoCase( key, property, '.') ) {
								try {
									setProperty( cfc, key, { '#key#' = memento[ key ] } );
								} catch ( any e ) {
									onPopulateError( cfc, key, memento);
								}
							}
						}
					}
				}
			}
		} else {
			var setters = findImplicitAndExplicitSetters( cfc );
			var keyArray = listToArray( keys );
			for ( var property in keyArray ) {
				var trimProperty = trim( property );
				if ( structKeyExists( setters, trimProperty ) || trustKeys ) {
					if ( structKeyExists( memento, trimProperty ) ) {
						var args = { };
						args[ trimProperty ] = memento[ trimProperty ];
						if ( trim && isSimpleValue( args[ trimProperty ] ) ) args[ trimProperty ] = trim( args[ trimProperty ] );
						// cfc[ 'set'&trimproperty ]( argumentCollection = args ); // ugh! no portable script version of this?!?!
						setProperty( cfc, trimProperty, args );
					}
				} else if ( deep ) {
					if ( listLen( trimProperty, '.' ) > 1 ) {
						var prop = listFirst( trimProperty, '.' );
						if ( structKeyExists( cfc, 'get' & prop ) ) {
                            setProperty( cfc, trimProperty, { '#trimProperty#' = memento[ trimProperty ] } );
                        }
					}
				}
			}
		}
		return cfc;
	}
	
	void function save( Entity ){
		EntitySave( arguments.Entity );
	}
	
	
	/* ---------------------------- DYNAMIC ---------------------------- */  
	
	
	function onMissingMethod( string missingMethodName, struct missingMethodArguments ){
		if ( ReFind( "^find(All)?By", arguments.missingMethodName ) ){
			var properties = ListToArray( Replace( ReReplace( arguments.missingMethodName, "^find(All)?By", "" ), "And", "|" ), "|" );
			var filtercriteria = {};
			var likeQuery = ReFind( "Like$", arguments.missingMethodName ) != 0;
			for ( var i=1; i<= ArrayLen( properties ); i++ ){
				if ( likeQuery ){
					properties[ i ] = ReReplace( properties[ i ], "Like$", "" );
				}
				filtercriteria[ properties[ i ] ] = missingMethodArguments[ i ];
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
	
	
	/*
	findImplicitAndExplicitSetters method is taken from https://github.com/seancorfield/fw1/blob/master/org/corfield/framework.cfc

	Copyright (c) 2009-2012, Sean Corfield, Ryan Cogswell

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
	*/
	private struct function findImplicitAndExplicitSetters( any cfc ) {
		var baseMetadata = getMetadata( cfc );
		var setters = { };
		// is it already attached to the CFC metadata?
		if ( structKeyExists( baseMetadata, '__fw1_setters' ) )  {
			setters = baseMetadata.__fw1_setters;
		} else {
			var md = { extends = baseMetadata };
			do {
				md = md.extends;
				var implicitSetters = false;
				// we have implicit setters if: accessors="true" or persistent="true"
				if ( structKeyExists( md, 'persistent' ) && isBoolean( md.persistent ) ) {
					implicitSetters = md.persistent;
				}
				if ( structKeyExists( md, 'accessors' ) && isBoolean( md.accessors ) ) {
					implicitSetters = implicitSetters || md.accessors;
				}
				if ( structKeyExists( md, 'properties' ) ) {
					// due to a bug in ACF9.0.1, we cannot use var property in md.properties,
					// instead we must use an explicit loop index... ugh!
					var n = arrayLen( md.properties );
					for ( var i = 1; i <= n; ++i ) {
						var property = md.properties[ i ];
						if ( implicitSetters ||
								structKeyExists( property, 'setter' ) && isBoolean( property.setter ) && property.setter ) {
							setters[ property.name ] = 'implicit';
						}
					}
				}
			} while ( structKeyExists( md, 'extends' ) );
			// cache it in the metadata (note: in Railo 3.2 metadata cannot be modified
			// which is why we return the local setters structure - it has to be built
			// on every controller call; fixed in Railo 3.3)
			baseMetadata.__fw1_setters = setters;
		}
		// gather up explicit setters as well
		for ( var member in cfc ) {
			var method = cfc[ member ];
			var n = len( member );
			if ( isCustomFunction( method ) && left( member, 3 ) == 'set' && n > 3 ) {
				var property = right( member, n - 3 );
				setters[ property ] = 'explicit';
			}
		}
		return setters;
	}
	
	
	
	/*
	setProperty method taken from https://github.com/seancorfield/fw1/blob/master/org/corfield/framework.cfc
	
	Copyright (c) 2009-2012, Sean Corfield, Ryan Cogswell

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
	*/
	private void function setProperty( struct cfc, string property, struct args ) {
		if ( listLen( property, '.' ) > 1 ) {
			var firstObjName = listFirst( property, '.' );
			var newProperty = listRest( property,  '.' );

			args[ newProperty ] = args[ property ];
			structDelete( args, property );

			if ( structKeyExists( cfc , 'get' & firstObjName ) ) {
				var obj = getProperty( cfc, firstObjName );
				if ( !isNull( obj ) ) setProperty( obj, newProperty, args );
			}
		} else {
			evaluate( 'cfc.set#property#( argumentCollection = args )' );
		}
	}
	
	private void function onPopulateError( any cfc, string property, struct rc ) {
	}
	
}