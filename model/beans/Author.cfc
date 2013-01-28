component persistent="true" {

	property name="id" fieldtype="id" setter="false" generator="native" ormtype="integer";
	property name="forename" ormtype="string" length="50";
	property name="surname" ormtype="string" length="50";
	
}   