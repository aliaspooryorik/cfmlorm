<cfscript>
	
	
testSuite = CreateObject( "mxunit.framework.TestSuite" ).TestSuite();
testSuite.addAll( "_tests.lib.AbstractDAOTest" );
testSuite.addAll( "_tests.lib.AbstractServiceTest" );
testSuite.addAll( "_tests.lib.DAOFactoryTest" );
testSuite.addAll( "_tests.lib.DAOFactoryTestWithBeanFactory" );

results = testSuite.run();

writeOutput(results.getResultsOutput('html'));
</cfscript>