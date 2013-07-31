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
	 
	any function init(){
		return this;
	}
	
	
	/* ---------------------------- PUBLIC ---------------------------- */
	
	void function populate( required any obj, required struct memento ){
		for ( var key in arguments.memento ){
			evaluate( 'arguments.obj.set#key#(arguments.memento[ key ])' );
		}
	}

}