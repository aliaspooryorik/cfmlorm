component persistent="true" {

	property name="id" fieldtype="id" setter="false" generator="native" ormtype="integer";
	property name="title" ormtype="string" length="50";
}