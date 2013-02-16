component {

	/* ---------------------------- CONSTRUCTOR ---------------------------- */  
	any function init(){
		variables.gateways = {};
		return this;
	}
	
	/* ---------------------------- PUBLIC ---------------------------- */
	any function getGateway( required entityName ){
		lock name="GATEWAYFACTORY_GETGATEWAY_#UCase( arguments.entityName )#" timeout="5"{
			if ( !StructKeyExists( variables.gateways, arguments.entityName ) ) {
				variables.gateways[ arguments.entityName ] = createGateway( arguments.entityName );	
			}
		}
		return variables.gateways[ arguments.entityName ];
	}
	
	boolean function hasGateway( required entityName ){
		return StructKeyExists( variables.gateways, arguments.entityName );
	} 
	
	/* ---------------------------- PRIVATE ---------------------------- */
	
	private any function createGateway( required entityName ){
		return new AbstractGateway( arguments.entityName );
	}
}