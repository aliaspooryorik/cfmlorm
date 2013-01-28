component {
	this.datasource = "cfmlorm";
	this.ormenabled = true;
	
	function onRequestStart(){
		//application.beanfactory = new ioc();
		ORMReload();
	}
}