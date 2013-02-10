component {
	this.datasource = "cfmlorm";
	this.ormenabled = true;
	
	function onRequestStart(){
		ORMReload();
	}
}