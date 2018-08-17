# DGIWG Metadata Foundation 2.0

This GeoNetwork schema plugin implements the DMF/core metadata class,
defined in the document ([link](http://www.dgiwg.org/dgiwg/htm/documents/standards_implementation_profiles.htm))
   - DGIWG 114  
     DGIWG Metadata Foundation  
     Edition 2.0  
     Document date 2017 07 12  

This schema plugin has been developed on GeoNetwork 3.2.3 and should work on 3.2.3 or greater versions.

## Installing the plugin

### GeoNetwork version to use with this plugin

Use GeoNetwork 3.2.3+ version.  
It'll not be supported in 2.10.x or 3.0.x series so don't plug it into it!

### Adding the plugin to the source code

The best approach is to add the plugin as a submodule into GeoNetwork schema module.

```
cd schemas
git submodule add -b 3.2.x https://github.com/metadata101/iso19139.dgiwg iso19139.dgiwg
```

Add the new module to the `schema/pom.xml`:

```
  <module>iso19139</module>
  <module>iso19139.dgiwg</module>
</modules>
```

Add the dependency in the web module in `web/pom.xml`:

```
<dependency>
  <groupId>${project.groupId}</groupId>
  <artifactId>schema-iso19139.dgiwg</artifactId>
  <version>${project.version}</version>
</dependency>
```

Add the module to the webapp in web/pom.xml:

```
<execution>
  <id>copy-schemas</id>
  <phase>process-resources</phase>
  ...
  <resource>
    <directory>${project.basedir}/../schemas/iso19139.dgiwg/src/main/plugin</directory>
    <targetPath>${basedir}/src/main/webapp/WEB-INF/data/config/schema_plugins</targetPath>
  </resource>
```

### Build the application 

Once the application is build, the war file contains the schema plugin:

```
$ mvn clean install -Penv-prod
```

### Deploy the profile in an existing installation

After building the application, it's possible to deploy the schema plugin manually in an existing GeoNetwork installation:

- Copy the content of the folder `schemas/iso19139.dgiwg/src/main/plugin` to
  `INSTALL_DIR/geonetwork/WEB-INF/data/config/schema_plugins/iso19139.dgiwg`

There's no need to copy the jar file `schemas/iso19139.dgiwg/target/schema-iso19139.dgiwg-3.2.x-SNAPSHOT.jar` to
  `INSTALL_DIR/geonetwork/WEB-INF/lib`, since there's no java class or spring file needed for the DGIWG profile.


### Adding editor configuration

Once the application started, check the plugin is loaded in the admin > standard page.
Then in admin > Settings, add to metadata/editor/schemaConfig the editor configuration for the schema:

    "iso19139.dgiwg":{
      "defaultTab":"DMFcore",
      "displayToolTip":false,
      "related":{
        "display":true,
        "categories":[]},
      "suggestion":{"display":true},
      "validation":{"display":true}}

### Adding Thesauri

In the [plugin directory](https://github.com/metadata101/iso19139.dgiwg/tree/master/src/main/plugin/iso19139.dgiwg/thesauri) there is a set of thesauri related to NGMP codelists.

You need to upload all of them into GeoNetwork in order to be able to edit e set
of fields (some of them are mandatory)

