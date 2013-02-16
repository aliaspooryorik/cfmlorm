component {

	/* ---------------------------- CONSTRUCTOR ---------------------------- */  
	any function init( required entityName ){
		variables.entityName = arguments.entityname;
		return this;
	}
	
	/* ---------------------------- PUBLIC ---------------------------- */
	
	/* ---------------------------- PUBLIC ---------------------------- */
	
	boolean function delete( required any arg ){
		var result = false;
		if ( IsObject( arguments.arg ) ){
			EntityDelete( arguments.arg );
			result = true;
		}
		return result;
	}

	boolean function deleteByID( required id ){
		var entity = get( variables.entityname, arguments.id );
		var result = false;
		if ( !IsNull( entity ) ){
			result = delete( entity );
		}
		return result;
	}

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
			return new( variables.entityname );
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
	
	any function new( struct memento={} ){
		return EntityNew( variables.entityname, arguments.memento );
	}

	void function save( required any entity ){
		EntitySave( arguments.entity );
	}
	
	array function where( required string clause, struct params={} ){
		var hql = 'from ' & variables.entityname & ' where ' & arguments.clause;
		return ORMExecuteQuery( hql, arguments.params );
	}
	
	any function executeQuery( required hql, params={}, unique=false, queryOptions={} ){
		return ORMExecuteQuery( arguments.hql, arguments.params, arguments.unique, arguments.queryOptions );
	}
	
}