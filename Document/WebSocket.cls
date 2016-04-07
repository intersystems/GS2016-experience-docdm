Include (%occInclude, %cspInclude, %occIO)

Class Document.WebSocket Extends %CSP.WebSocket
{

Method OnPreServer() As %Status
{
  set ..SharedConnection=1
  if (..WebSocketID'=""){
    set ^CacheTemp.Experience.WebSocket(..WebSocketID)=""
    set db = ##class(%DataModel.Document.Database).$getDatabase()
    do db.$dropCollection("doNotTouch-Stats")
    do db.$dropCollection("doNotTouch")
    set ^CacheTemp.Experience("stage") = 1
	set ^CacheTemp.Experience("level") = 1
  } else {
    set ^CacheTemp.Experience.Error($INCREMENT(^CacheTemp.Experience.Error),"no websocketid defined")=$HOROLOG 
  }

  Quit $$$OK
}

Method Server() As %Status
{
    for {                
    	set data=..Read(.size,.sc,1) 
    	if ($$$ISERR(sc)){
        	if ($$$GETERRORCODE(sc)=$$$CSPWebSocketTimeout) {
                              //$$$DEBUG("no data")
          	}
          	if ($$$GETERRORCODE(sc)=$$$CSPWebSocketClosed){
                  kill ^CacheTemp.Experience.WebSocket(..WebSocketID)
                  do ..EndServer()        
                  Quit  // Client closed WebSocket
          	}
     	} else {
			// set current stage and level
			set jsonData = ##class(%AbstractObject).$fromJSON(data)
			if (jsonData.type = "update") {
				set ^CacheTemp.Experience("stage") = jsonData.stage
				set ^CacheTemp.Experience("level") = jsonData.level
			}
     	}
	}

	Quit $$$OK
}

ClassMethod LevelUp(stage = 1, level = 1)
{
	set msg=##class(%Object).$new()
	set msg.stage=stage
	set msg.level=level
	set msg.type ="LevelUp"

	try {
		
		set key = $O(^CacheTemp.Experience.WebSocket(""))
		while key '= "" {
		
			set ws=..%New()
			set sc=ws.OpenServer(key)
			if $$$ISERR(sc){
				set ^CacheTemp.Experience.Error($INCREMENT(^CacheTemp.Experience.Error),"open failed for",c)=sc 
				kill ^CacheTemp.Experience.WebSocket(key)
			}
			set sc=ws.Write(msg.$toJSON())
			
			set key = $O(^CacheTemp.Experience.WebSocket(key))
		}
	
	} catch e {
		set ^CacheTemp.Experience.Error($INCREMENT(^CacheTemp.Experience.Error),"error")=e.DisplayString()
	}
}

ClassMethod EchoCommand(command)
{
	set msg=##class(%Object).$new()
	set msg.command=command
	set msg.type ="EchoCommand"
	
	#dim e As %Exception.AbstractException
	#dim sc As %Status
	
	try {

		set key = $O(^CacheTemp.Experience.WebSocket(""))
		while key '= "" {
		
			set ws=..%New()
			set sc=ws.OpenServer(key)
			if $$$ISERR(sc){
				set ^CacheTemp.Experience.Error($INCREMENT(^CacheTemp.Experience.Error),"open failed for",c)=sc 
				kill ^CacheTemp.Experience.WebSocket(key)
			}
			set sc=ws.Write(msg.$toJSON())
			set ^swi($H,"Send command") = $SYSTEM.Status.DisplayError(sc)
			
			set key = $O(^CacheTemp.Experience.WebSocket(key))
		}
	
	} catch e {
		set ^CacheTemp.Experience.Error($INCREMENT(^CacheTemp.Experience.Error),"error")=e.DisplayString()
	}
}

ClassMethod Help(message)
{
	set msg=##class(%Object).$new()
	set msg.message=message
	set msg.type ="Help"

	try {

		set key = $O(^CacheTemp.Experience.WebSocket(""))
		while key '= "" {
		
			set ws=..%New()
			set sc=ws.OpenServer(key)
			if $$$ISERR(sc){
				set ^CacheTemp.Experience.Error($INCREMENT(^CacheTemp.Experience.Error),"open failed for",c)=sc 
				kill ^CacheTemp.Experience.WebSocket(key)
			}
			set sc=ws.Write(msg.$toJSON())
			
			set key = $O(^CacheTemp.Experience.WebSocket(key))
		}
	
	} catch e {
		set ^CacheTemp.Experience.Error($INCREMENT(^CacheTemp.Experience.Error),"error")=e.DisplayString()
	}
}

}
