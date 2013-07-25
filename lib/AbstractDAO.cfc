/*
   Copyright 2013 John Whish

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
component {

	/* ---------------------------- CONSTRUCTOR ---------------------------- */ 
	 
	any function init( required entityName ){
		variables.entityName = arguments.entityname;
		return this;
	}
	
	
	/* ---------------------------- PUBLIC ---------------------------- */
	
	boolean function delete( required any entity ){
		var result = false;
		if ( IsObject( arguments.entity ) ){
			EntityDelete( arguments.entity );
			result = true;
		}
		return result;
	}

	boolean function deleteByID( required id ){
		var entity = get( arguments.id );
		var result = false;
		if ( !IsNull( entity ) ){
			result = delete( entity );
		}
		return result;
	}

	/*
	 * returns a single entity or null
	 */
	any function get( required any filter, boolean returnnew=false ){
		if ( IsSimpleValue( arguments.filter ) ){
			var result = EntityLoadByPK( variables.entityname, arguments.filter );
		}else{
			var matches = EntityLoad( variables.entityname, arguments.filter, {maxresults=1} );
			if ( ArrayLen( matches ) == 1 ){
				var result = matches[ 1 ];
			}
		}
		if ( arguments.returnnew && IsNull( result ) ){
			return new();
		}
		if ( !IsNull( result ) ){
			return result;
		}
	}
	
	string function getEntityName(){
		return variables.entityName;
	}
	
	array function list( struct filter={}, string sortorder='', struct options={} ){
		return EntityLoad( variables.entityname, arguments.filter, arguments.sortorder, arguments.options );
	}
	
	any function new( struct memento ){
		if ( StructKeyExists( arguments, "memento" ) ){
			// note: requires CF10 / Railo 4
			return EntityNew( variables.entityname, arguments.memento );
		}else{
			return EntityNew( variables.entityname );
		}
	}
	
	void function reload( required any entity ){
		EntityReload( arguments.entity );
	}

	void function save( required any entity ){
		EntitySave( arguments.entity );
	}
	
	/*
	 * returns an array or object depending on the value of the unique argument
	 */
	any function where( required string clause, params={}, boolean unique=false, struct queryOptions={} ){
		var hql = 'from ' & variables.entityname & ' where ' & arguments.clause;
		return executeQuery( hql, arguments.params, arguments.unique, arguments.queryOptions );
	}
	
	any function executeQuery( required string hql, params={}, boolean unique=false, struct queryOptions={} ){
		return ORMExecuteQuery( arguments.hql, arguments.params, arguments.unique, arguments.queryOptions );
	}
	
	/* ---------------------------- DYNAMIC ---------------------------- */
	
	/*
	 * adds a bit of syntax sugar 
	 */
	any function onMissingMethod( missingMethodName, missingMethodArguments ){
		var method = ReplaceNoCase( arguments.missingMethodName, variables.entityname, "" );
		switch ( method ){
			case "delete":
				return delete( argumentCollection=arguments.missingMethodArguments );
				break;
			case "get":
				return get( argumentCollection=arguments.missingMethodArguments );
				break;
			case "new":
				return new( argumentCollection=arguments.missingMethodArguments );
				break;
			case "list":
				return list( argumentCollection=arguments.missingMethodArguments );
				break;
			case "reload":
				return reload( argumentCollection=arguments.missingMethodArguments );
				break;
			case "save":
				return save( argumentCollection=arguments.missingMethodArguments );
				break;
			case "where":
				return where( argumentCollection=arguments.missingMethodArguments );
				break;
			default:
				throw( "unknow method: #arguments.missingMethodName#" );
		}
	}
}