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
component accessors="true" {

	/* Dependancies
	-------------------------------------------------------- */

	property name="BeanFactory";
	
	/* Constructor
	-------------------------------------------------------- */
	
	any function init(){
		variables.DAOs = {};
		return this;
	}
	
	/* Public Methods
	-------------------------------------------------------- */
	
	any function getDAO( required entityName ){
		var DAOName = arguments.entityName & "DAO";
		if ( !containsBean( DAOName ) ){
			lock name="create_#arguments.entityName#" timeout="10"{
				var VirtualDAO = new AbstractDAO( arguments.entityName );
				addBean( DAOName, VirtualDAO );			
			}
		}
		return getBean( DAOName );
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
	
	/* Private Methods
	-------------------------------------------------------- */
	
	private void function addBean( required beanName, required Bean ){
		if ( hasBeanFactory() ){
			variables.BeanFactory.addBean( arguments.beanName, arguments.Bean );
		}else{
			variables.DAOs[ arguments.beanName ] = arguments.Bean;
		}
	}
	
	private any function containsBean( required beanName ){
		if ( hasBeanFactory() ){
			return variables.BeanFactory.containsBean( arguments.beanName );
		}else{
			return StructKeyExists( variables.DAOs, arguments.beanName );
		}
	} 

	private string function extractEntityName( required string methodname ){
		// find index of last Uppercase character
		var ordinal = reFind( "[A-Z](?=[^A-Z]*$)", arguments.methodname );
		var result = Right( arguments.methodname, Len( arguments.methodname ) - ordinal + 1 );
		return result;
	}
	
	private any function getBean( required beanName ){
		if ( hasBeanFactory() ){
			return variables.BeanFactory.getBean( arguments.beanName );
		}else{
			return variables.DAOs[ arguments.beanName ];
		}
	}
	
	private boolean function hasBeanFactory(){
		return StructKeyExists( variables, "BeanFactory" );
	}

}
