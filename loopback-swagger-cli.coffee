#!/usr/bin/env node
fs = require 'fs'
clone = (e) -> JSON.parse JSON.stringify e
argv = require('minimist')(process.argv.slice(2))
console.dir argv if process.env.DEBUG?

merge = (source, obj, clone) ->
  prop = undefined
  v = undefined
  if source == null
    return source
  for prop of obj
    `prop = prop`
    v = obj[prop]
    if source[prop] != null and typeof source[prop] == 'object' and typeof obj[prop] == 'object'
      merge source[prop], obj[prop]
    else
      if clone
        source[prop] = @clone
      else
        source[prop] = obj[prop]
  source

modelconfig = 
  dataSource: "db"
  public: true
  
model = 
  name: ""
  base: "PersistedModel"
  idInjection: true
  options:
    validateUpsert: true
  properties:
    "id": 
      "type": "number"
      "required": true
      "format": "int64"
  validations:[]
  relations: {}
  acls:[]
  methods: []

if argv['_'].length < 3
  console.log "Usage: loopback-swagger-cli <swagger.json> <modeldir> <model-config.json>"
  process.exit 1

swaggerfile = argv['_'][0]
swaggerfile = "./" + swaggerfile if swaggerfile[0] != '/'
modeldir    = argv['_'][1]
modeldir = "./" + modeldir if modeldir[0] != '/'
modelconfigfile    = argv['_'][2]
modelconfigfile = "./" + modelconfigfile if modelconfigfile[0] != '/'


swagger = require swaggerfile 
if not swagger.definitions
  console.error "cannot find definitons field in swagger file"
  process.exit 1

config = {}
for name,options of swagger.definitions
  json = clone model
  json = merge json, options 
  console.log "writing "+modeldir+"/"+name+".json"
  fs.writeFileSync modeldir+"/"+name+".json", JSON.stringify( json, null, 2)
  # write config
  modelcfg = clone modelconfig
  modelcfg.dataSource = options.dataSource if options.dataSource?
  modelcfg.public = options.public if options.public?
  config[ name ] = modelcfg

fs.writeFileSync modelconfigfile, JSON.stringify( config,null,2)
  
