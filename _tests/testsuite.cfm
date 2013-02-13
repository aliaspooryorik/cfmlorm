<cfscript>
	
CUT = new model.ORMGateway();
	
testSuite = CreateObject( "mxunit.framework.TestSuite" ).TestSuite();
testSuite.addAll( "_tests.integration.model.AbstractGatewayTest" );
testSuite.addAll( "_tests.integration.model.GatewayFactoryTest" );
testSuite.addAll( "_tests.integration.model.ORMGatewayTest" );
results = testSuite.run();

writeOutput(results.getResultsOutput('html'));
</cfscript>