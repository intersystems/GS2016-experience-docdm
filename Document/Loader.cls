Class Document.Loader Extends %RegisteredObject
{

ClassMethod PreLoad(pMaxNumber = 10)
{
	#dim db = ##class(%DataModel.Document.Database).$getDatabase()
	#dim i, col, sc, response
	
	w "--- Retrieving Math Facts ---",!
	set col = db.$getCollection("preloaded-Numbers-Math-Facts")
	for i=1:1:pMaxNumber {
		if ('col.$isDefined(i)) {
			set response = ..GetMathFact(i)
			set sc = col.$insertAt(i,response)
		}
	}
	
	w "--- Retrieving Trivia Facts ---",!
	set col = db.$getCollection("preloaded-Numbers-Trivia-Facts")
	for i=1:1:pMaxNumber {
		if ('col.$isDefined(i)) {
			set response = ..GetTriviaFact(i)
			set sc = col.$insertAt(i,response)
		}
	}
}

ClassMethod GetMathFact(pNumber = 0) As %AbstractObject
{
	#dim requestURI = "https://numbersapi.p.mashape.com/"_pNumber_"/math?json=true"
	return ..MakeRequest(requestURI)
}

ClassMethod GetTriviaFact(pNumber = 0) As %AbstractObject
{
	#dim requestURI = "https://numbersapi.p.mashape.com/"_pNumber_"/trivia?json=true"
	return ..MakeRequest(requestURI)
}

ClassMethod MakeRequest(requestURI) As %AbstractObject
{
	#dim sslConfigurationName = "Default"
	#dim response = {}
	
	w requestURI,!
	
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
			do httprequest.SetHeader("X-Mashape-Key", "CgstLCrOuGmshY2c0vc4LDsQR5yBp1JK3FZjsnDMn5kwSlGfSJ")
			if $Data(requestComponent("username")) {
				set httprequest.Username = requestComponent("username")
			}
			if $Data(requestComponent("pwd")) {
				set httprequest.Password = requestComponent("password")
			}
			if (scheme = "https") && (sslConfigurationName '= "") {
				set httprequest.Https = 1
				set httprequest.SSLConfiguration = sslConfigurationName
			}
			set status = httprequest.Get($Get(requestComponent("path"))_$Select($Get(requestComponent("query"))="":"",1:"?"_requestComponent("query"))_$Select($Get(requestComponent("params"))="":"",1:";"_requestComponent("params")))
			if $$$ISERR(status) {
				$$$ThrowStatus(status)
			}
			set response = ##class(%AbstractObject).$fromJSON(httprequest.HttpResponse.Data)
		}
	} catch exception {
		set response = $$$NULLOREF
		throw exception
	}
	return response
}

/// From Demo.Document.Data.Loader in the SAMPLES namespace
ClassMethod loadCities(folder As %CacheString = "")
{
	try {
		if $zs < $$$MaxPartitionSize {
			set oldSize=$zs, $zs=$$$MaxPartitionSize
		} else {
			set oldSize = ""
		}
		if folder = "" {
			set currentFolder = ^Sources _"databases/samples/gbl/"
		} else {
			set currentFolder = folder
		}
		set db = ##class(%DataModel.Document.Database).$getDatabase()
		set file =  currentFolder _ "cities-en.json"
		try {
			do db.$dropCollection("cities")
		} catch dropEx {
				// we don't care if the collection doesn't exist - SQLCODE = -2030
			if ('dropEx.%IsA("%DataModel.Document.SYS.Exception")) || (dropEx.AsSQLCODE() '= -2030) {
				throw dropEx
			}
		}
		set cities = db.$getCollection("cities")
		do cities.$createIndex("NX",{"key":[["name","string"]],"type":"map"})
		do cities.$createIndex("CX",{"key":[["country","string"]],"type":"bitmap"})
		do cities.$createIndex("LX",{"key":[["longitude","numeric"],["latitude","numeric"]],"type":"map"})
		write !,"cities(): loaded "
		set start = $zh
		do cities.$fromJSON(file)
		set et = $zh-start
		write cities.$size()_" documents in "_et_" seconds."
		if oldSize '= "" {
			set $zs = oldSize
			set oldSize = ""
		}
	} catch exception {
		if $Get(oldSize) '= "" {
			set $zs = oldSize
		}
		throw exception
	}
	return cities
}

}
