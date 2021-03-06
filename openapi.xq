xquery version "3.1";

(: when using the library in other module the location part («at») SHOULD be
ommited as the library registers its namespace to eXist. :)
import module namespace openapi="https://lab.sub.uni-goettingen.de/restxqopenapi"
  at "content/openapi.xqm";

(: prepare a json document on HTTP requests :)
declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "json";
declare option output:media-type "application/json";

let $thisPath := replace(system:get-module-load-path(),
'^(xmldb:exist://)?(embedded-eXist-server)?(.+)$', '$3')

(: we register the REST interface :)
let $prepare :=
  if(xs:boolean(request:get-parameter("register", "false")))
  then
    xmldb:get-child-resources($thisPath || "/content")[. != "openapi.xqm"]
    ! exrest:register-module(xs:anyURI($thisPath || "/content/" || .))
  else ()

(: locate the target path :)
let $target := request:get-parameter("target", $thisPath)
return

(: prepare OpenAPI as map(*) :)
openapi:main($target)
