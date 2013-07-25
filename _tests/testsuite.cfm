<cfscript>
	
	
testSuite = CreateObject( "mxunit.framework.TestSuite" ).TestSuite();
testSuite.addAll( "_tests.lib.AbstractDAOTest" );
testSuite.addAll( "_tests.lib.DAOFactoryTest" );

results = testSuite.run();

writeOutput(results.getResultsOutput('html'));
</cfscript>