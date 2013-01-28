component persistent="true" table="groups"{

	property name="groupid" fieldtype="id" setter="FALSE" generator="native" column="group_id" sqltype="int(11)";
	property name="title" column="group_title" ormtype="string" length="50";
	
}   