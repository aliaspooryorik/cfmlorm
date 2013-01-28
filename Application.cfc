component {
	this.datasource = "pineandoakoutlet";
	this.ormenabled = true;
	
	function onRequestStart(){
		//application.beanfactory = new ioc();
		ORMReload();
	}
}