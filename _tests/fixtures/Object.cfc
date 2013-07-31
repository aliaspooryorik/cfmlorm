component accessors="true" {

	property name="foo";
	
	function init(){
		variables.foo = '';
		variables.bar = '';
	}
	
	function getBar(){
		return variables.bar;
	}
	function setBar( value ){
		variables.bar = arguments.value;
	}
	
	function onMissingMethod( missingMethodName, missingMethodArguments ){
		if ( Left( arguments.missingMethodName, 3 ) == "set" ){
			variables[ getVariableName( arguments.missingMethodName ) ] = arguments.missingMethodArguments[1];
		}
		else if ( Left( arguments.missingMethodName, 3 ) == "get" ) {
			return variables[ getVariableName( arguments.missingMethodName ) ];
		}
	}
	
	private function getVariableName(methodname){
		return reReplaceNoCase(arguments.methodname, '^(get|set)', '');
	}

}