component persistent="true" {
	property name="id" fieldtype="id" setter="false" generator="native" ormtype="integer";
	property name="posts" fieldtype="many-to-one" fkcolumn="fk_post" cfc="Post" singularname="Post" orderby="title";
	property name="tags" fieldtype="many-to-one" fkcolumn="fk_tag" cfc="Tag" singularname="Tag" orderby="title";
}