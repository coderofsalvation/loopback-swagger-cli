The loopback:swagger converter is nice, and this tool makes it a bit nicer:

* batch conversion (without interaction needed)
* copy relations,acl etc defined in swagger

Basically it allows you to do a swagger/loopback syntax-mashup in 1 jsonfile.
This allows you to model your api's using one model file.
(instead of slapping your head around files)

# Usage

    npm install -g loopback-swagger-cli

then extend your swagger file with strongloop syntax like so:

    {
      ...
      "pet": {
        "type": "object",
        "required": [
          "id",
          "name"
        ],
        "dataSource": "db",          <--
        "public":true,               <--
        "relations": {               <--
          "owner": {                 <-- see strongloop 
            "type": "belongsTo",     <-- model jsondocs for
            "model": "owner",        <-- fields / syntax
            "foreignKey": ""         <--
          }                          <--
        },
      ...

and then
  
    $ slc loopback:swagger swagger.json # only needed once (see note)
    $ loopback-swagger-cli swagger.json server/models server/model-config.json
    writing /server/models/owner.json
    writing /server/models/pet.json 
    writing /server/model-config.json

> NOTE: this cli-tool will leave the .js files alone, however use the loopback:swagger cmd
to generate them otherwise loopback will complain.

# Example repo

here's an example of a loopback api served from one coffeescript-jsonfile:

[https://github.com/coderofsalvation/loopback-swagger-cli-example](https://github.com/coderofsalvation/loopback-swagger-cli-example)

