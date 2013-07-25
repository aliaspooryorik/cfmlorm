/**
* I am a the base service which all services should extend
*/
component accessors="true" {
	
	pageencoding "utf-8";
	
	/* DI
	-------------------------------------------------------------- */
	
	property name="DAOFactory" inject="model:abstract.DAOFactory";
	
	
	/* PUBLIC
	-------------------------------------------------------------- */
	
	any function init(){
		return this;
	}
	
	
	/* PRIVATE
	-------------------------------------------------------------- */
	
}