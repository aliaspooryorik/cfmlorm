<cfscript>
testSuite = CreateObject( "mxunit.framework.TestSuite" ).TestSuite();
testSuite.addAll( "_tests.integration.model.GatewayFactoryTest" );
results = testSuite.run();

writeOutput(results.getResultsOutput('html'));
</cfscript>