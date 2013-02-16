<cfscript>
	
	
testSuite = CreateObject( "mxunit.framework.TestSuite" ).TestSuite();
testSuite.addAll( "_tests.integration.model.abstract.DAOTest" );
testSuite.addAll( "_tests.integration.model.abstract.AbstractGatewayTest" );
testSuite.addAll( "_tests.integration.model.abstract.GatewayFactoryTest" );
testSuite.addAll( "_tests.integration.model.abstract.ORMGatewayTest" );
results = testSuite.run();

writeOutput(results.getResultsOutput('html'));
</cfscript>