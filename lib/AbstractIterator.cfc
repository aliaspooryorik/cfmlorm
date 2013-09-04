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
	 
	AbstractIterator function init( q ){
		variables.recordset = [];
		variables.recordcount = 0;
		variables.cursor = 0;
		if ( StructKeyExists( arguments, "q" ) ){
			setQuery( arguments.q );
		}
		return this;
	}
	
	/* ---------------------------- PUBLIC ---------------------------- */
	
	
	/* --- Methods for computed values ---------------------------- */
	
	/* --- Iterator methods ---------------------------- */
	
	void function setQuery( required query q ){
		variables.query = arguments.q;
		variables.recordset = [];
		
		for ( var i=1; i<=variables.query.recordcount; i++ ){
			var row = {};
			// note: in Railo can just do "for( row in recordcount)" 
			for ( var col in ListToArray( variables.query.columnlist ) ){
				row[ col ] = variables.query[ col ][ i ];	
			}
			arrayAppend( variables.recordset, row );
		}
		variables.recordcount = variables.query.recordCount;
	}

	// returns true if not at the end of the records
	boolean function hasNext(){
		if ( variables.recordcount > variables.cursor ){
			variables.cursor++;
			return true;
		}else{
			return false;
		}
	}

	// returns the value for current cursor position 
	any function get( key ){
		return variables.recordset[ variables.cursor ][ key ];
	}
	
	numeric function getCursor(){
		return variables.cursor;
	}
	
	numeric function getRecordcount(){
		return variables.recordcount;
	}
	
	query function getQuery(){
		return variables.query;
	}
	
	// returns an array of structs, only here for debugging
	array function getRecordset(){
		return variables.recordset;
	}
	
	string function getAsJSON(){
		return SerializeJSON( variables.recordset );
	}
	
	boolean function hasRecords(){
		return variables.recordcount > 0;
	}
	
	/* ---------------------------- DYNAMIC ---------------------------- */
	
	// Allow for get*key*() style calls without needing to create getters
	
	any function onMissingMethod( missingMethodName, missingMethodArguments ){
		var prefix = Left( arguments.missingMethodName, 3 );
		if ( "get" == prefix ){
			var key = Right(arguments.missingMethodName, len( arguments.missingMethodName ) - 3 );
			return get( key );			
		}
		else{
			throw "method '#arguments.missingMethodName#' not found";
		}
	}
	
	/* ---------------------------- PRIVATE ---------------------------- */


}
