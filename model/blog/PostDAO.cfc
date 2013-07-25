component extends="lib.AbstractDAO" {
	
	/* ---------------------------- CONSTRUCTOR ---------------------------- */  
	any function init(){
		return super.init( 'Post' );
	}
	
	boolean function concreteMethod(){
		return true;
	}
	
}