component accessors="true" {

	property name="BeanFactory";
	
	any function init(){
		return this;
	}
	
	any function getDAO( required entityName ){
		var gatewayName = arguments.entityName & "DAO";
		if ( !variables.BeanFactory.containsBean( gatewayName ) ){
			lock name="create_#arguments.entityName#" timeout="10"{
				var VirtualDAO = new AbstractDAO( arguments.entityName );
				variables.BeanFactory.addBean( gatewayName, VirtualDAO );			
			}
		}
		return variables.BeanFactory.getBean( gatewayName );
	}
	
	any function onMissingMethod( missingMethodName, missingMethodArguments ){
		if ( ReFindNoCase( "DAO$" , arguments.missingMethodName ) ){
			// just return the DAO
			var entityDAO = getDAO( ReReplaceNoCase( arguments.missingMethodName, "DAO$", "" ) );
			return entityDAO;
		}else{
			// load and delegate
			var entityName = extractEntityName( arguments.missingMethodName );
			var entityDAO = getDAO( entityName );
			var methodname = replace( arguments.missingMethodName, entityName, "" );
			return evaluate( 'entityDAO.#methodname#( argumentCollection=arguments.missingMethodArguments )' );
		}
	}
	
	private string function extractEntityName( required string methodname ){
		// find index of last Uppercase character
		var ordinal = reFind( "[A-Z](?=[^A-Z]*$)", arguments.methodname );
		var result = Right( arguments.methodname, Len( arguments.methodname ) - ordinal + 1 );
		return result;
	}

}
