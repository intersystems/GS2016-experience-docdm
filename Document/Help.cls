Class Document.Help Extends %RegisteredObject
{

/// Step 1-4
ClassMethod ListCollections()
{
	set db = ##class(%DataModel.Document.Database).$getDatabase()
	set iter = db.databaseCollection.$getIterator()
	while iter.$getNext(.collectionID) {
		w db.databaseCollection.$get(collectionID).name,!
	}
}

/// Step 2-1
ClassMethod FromURI(requestURI As %CacheString = "", sslConfigurationName As %CacheString = "") As %AbstractObject
{
	try {
		do ##class(%Net.URLParser).Parse(requestURI,.requestComponent)
		set scheme = $Get(requestComponent("scheme"))
		if $Extract(scheme,1,4) = "http" {
				// Thanks to DMC
			set httprequest = ##class(%Net.HttpRequest).%New()
			set httprequest.Server = requestComponent("host")
			if $Data(requestComponent("port")) {
				set httprequest.Port = requestComponent("port")
			}
			do httprequest.SetHeader("Accept","application/json")
			do httprequest.SetHeader("ContentType","application/json")
			if $Data(requestComponent("username")) {
				set httprequest.Username = requestComponent("username")
			}
			if $Data(requestComponent("pwd")) {
				set httprequest.Password = requestComponent("password")
			}
			
			// hardcode username and password for now
			set httprequest.Username = "_SYSTEM"
			set httprequest.Password = "SYS"
			
			if (scheme = "https") && (sslConfigurationName '= "") {
				set httprequest.Https = 1
				set httprequest.SSLConfiguration = sslConfigurationName
			}
			set status = httprequest.Get($Get(requestComponent("path"))_$Select($Get(requestComponent("query"))="":"",1:"?"_requestComponent("query"))_$Select($Get(requestComponent("params"))="":"",1:";"_requestComponent("params")))
			if $$$ISERR(status) {
				$$$ThrowStatus(status)
			}
			set response = ##class(%AbstractObject).$fromJSON(httprequest.HttpResponse.Data)
		}/* elseif $Extract(requestURI,1,1) = "/" {
			// relative
			set httprequest = ##class(%Net.HttpRequest).%New()
			do httprequest.SetHeader("Accept","application/json")
			do httprequest.SetHeader("ContentType","application/json")
			set status = httprequest.Get($Get(requestComponent("path"))_$Select($Get(requestComponent("query"))="":"",1:"?"_requestComponent("query"))_$Select($Get(requestComponent("params"))="":"",1:";"_requestComponent("params")))
			if $$$ISERR(status) {
				$$$ThrowStatus(status)
			}
			set response = ##class(%AbstractObject).$fromJSON(httprequest.HttpResponse.Data)
		}*/ elseif scheme = "file" {
				// file - is this always local?
			set response = $$$NULLOREF
		} else {
			// unsupported scheme or no default scheme defined (this is presently the case)
			set response = $$$NULLOREF	
		}
	} catch exception {
		set response = $$$NULLOREF
		throw exception
	}
	return response
}

/// Step 2-4
ClassMethod Import(collection, data)
{

	try {
		
		set iter = data.content.$getIterator()
		while iter.$getNext(.key,.document) {
			set status = collection.$upsert(document.documentID,document.content)
		}
		
	} catch e {
		
	}
}

}
