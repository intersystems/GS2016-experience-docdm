Class Document.RuleEngine Extends %RegisteredObject
{

ClassMethod CheckUpgradeConditions(command)
{
	set ^swi($H,"CheckUpgradeConditions") = ""
	#dim db = ##class(%DataModel.Document.Database).$getDatabase()
	#dim stage = ^CacheTemp.Experience("stage")
	#dim level = ^CacheTemp.Experience("level")
	#dim id = stage_"-"_level
	
	#dim col = db.$getCollection("doNotTouch-Stats")
	#dim document = col.$get(id)
	
	if (document) {
		
		set document.commandCount = document.commandCount + 1
		do col.$upsert(id,document)
		
	} else {
		
		set document = {"commandCount":1,"shownHelp":false,"steps":{}}
		set sc = col.$insertAt(id,document)
		
	}
	
	if (stage = 1) {
		
		if (level = 1) {
			// nothing to do at the server side			
		} elseif (level = 2) {
			// get the database handle
			if ($FIND(command,"$getDatabase()") > 0) {
				do ..LevelUp()
			}
		} elseif (level = 3) {
			if ($FIND(command,".databaseCollection.$size()") > 0) {
				do ..LevelUp()
			}
		} elseif (level = 4) {
			if ($FIND(command,".$getIterator(") > 0) {
				do document.steps.$set("iterator",1,"boolean")
			}
			if ($FIND(command,".$getNext(") > 0) {
				do document.steps.$set("iterated",1,"boolean")
			}
			if ($FIND(command,".name") > 0) {
				do document.steps.$set("access_name",1,"boolean")
			}
			set sc = col.$upsert(id,document)
			
			if (document.steps.iterator && document.steps.iterated && document.steps."access_name") {
				do ..LevelUp()
			} elseif ($FIND(command,"##class(Document.Help).ListCollections()") > 0) {
				// someone lazy? :)
				do ..LevelUp()
			}
			
		} elseif (level = 6) {
			if ($FIND(command,".$getCollection(") > 0) {
				do ..LevelUp()
			}
		} elseif (level = 7) {
			if ($FIND(command,".$size()") > 0) {
				do ..LevelUp()
			}
		} elseif (level = 8) {
			if ($FIND(command,".$get(") > 0) {
				do ..LevelUp()
			}
		} elseif (level = 9) {
			if ($FIND(command,".$toJSON(") > 0) {
				do ..LevelUp()
			}
		} elseif (level = 10) {
			if ($FIND(command,".$get(") > 0) {
				do ..LevelUp()
			} elseif ($FIND(command,".text") > 0) {
				do ..LevelUp()
			}
		}
		
	} elseif (stage = 2) {
	
		if (level = 1) {
			
			if ($FIND(command,"/api/document/v1/gs/preloaded-Numbers-Math-Facts") > 0) {
				do document.steps.$set("url",1,"boolean")
			}
			if ($FIND(command,"##class(Document.Help).FromURI(") > 0) {
				do document.steps.$set("fromURI",1,"boolean")
			}
			
			set sc = col.$upsert(id,document)
			
			if (document.steps.url && document.steps.fromURI) {
				do ..LevelUp()
			}
			
		} elseif (level = 2) {
			if ($FIND(command,".$toJSON()") > 0) {
				do ..LevelUp()
			}
		} elseif (level = 3) {
			if ($FIND(command,"db.$getCollection(""mathFacts""") > 0) {
				do ..LevelUp()
			}
		} elseif (level = 4) {
			if ($FIND(command,"Document.Help).Import") > 0) {
				do ..LevelUp()
			}
		} elseif (level = 5) {
			if ($FIND(command,".$size()") > 0) {
				do ..LevelUp()
			}
		} elseif (level = 6) {
			if ($FIND(command,".$get(") > 0) {
				do document.steps.$set("get",1,"boolean")
			}
			if ($FIND(command,".$toJSON()") > 0) {
				do document.steps.$set("toJSON",1,"boolean")
			}
			
			set sc = col.$upsert(id,document)
			
			if (document.steps.get && document.steps.toJSON) {
				do ..LevelUp()
			}
		}
		
	} elseif (stage = 3) {
	
		if (level = 1) {
			// nothing to do
		} elseif (level = 2) {
		
			if ($FIND(command,"SELECT") > 0) {
				do document.steps.$set("SELECT",1,"boolean")
			}
			if ($FIND(command,"COUNT(") > 0) {
				do document.steps.$set("COUNT",1,"boolean")
			}
			if ($FIND(command,"JSON_TABLE(") > 0) {
				do document.steps.$set("JSON_TABLE",1,"boolean")
			}
			if ($FIND(command,"mathFacts") > 0) {
				do document.steps.$set("collectionName",1,"boolean")
			}
			if ($FIND(command,"COLUMNS") > 0) {
				do document.steps.$set("COLUMNS",1,"boolean")
			}
			
			set sc = col.$upsert(id,document)
			
			if (document.steps.SELECT && document.steps.COUNT && document.steps."JSON_TABLE" && document.steps.collectionName && document.steps.COLUMNS) {
				do ..LevelUp()
			}
			
		} elseif (level = 3) {
		
			if ($FIND(command,"SELECT") > 0) {
				do document.steps.$set("SELECT",1,"boolean")
			}
			if ($FIND(command,"number") > 0) {
				do document.steps.$set("number",1,"boolean")
			}
			if ($FIND(command,"JSON_TABLE(") > 0) {
				do document.steps.$set("JSON_TABLE",1,"boolean")
			}
			if ($FIND(command,"mathFacts") > 0) {
				do document.steps.$set("collectionName",1,"boolean")
			}
			if ($FIND(command,"COLUMNS") > 0) {
				do document.steps.$set("COLUMNS",1,"boolean")
			}
			
			set sc = col.$upsert(id,document)
			
			if (document.steps.SELECT && document.steps.number && document.steps."JSON_TABLE" && document.steps.collectionName && document.steps.COLUMNS) {
				do ..LevelUp()
			}
			
		} elseif (level = 4) {
		
			if ($FIND(command,"SELECT") > 0) {
				do document.steps.$set("SELECT",1,"boolean")
			}
			if ($FIND(command,"number") > 0) {
				do document.steps.$set("number",1,"boolean")
			}
			if ($FIND(command,"text") > 0) {
				do document.steps.$set("text",1,"boolean")
			}
			if ($FIND(command,"JSON_TABLE(") > 0) {
				do document.steps.$set("JSON_TABLE",1,"boolean")
			}
			if ($FIND(command,"mathFacts") > 0) {
				do document.steps.$set("collectionName",1,"boolean")
			}
			if ($FIND(command,"COLUMNS") > 0) {
				do document.steps.$set("COLUMNS",1,"boolean")
			}
			
			set sc = col.$upsert(id,document)
			
			if (document.steps.SELECT && document.steps.number && document.steps.text && document.steps."JSON_TABLE" && document.steps.collectionName && document.steps.COLUMNS) {
				do ..LevelUp()
			}
			
		} elseif (level = 5) {
		
			if ($FIND(command,"db.$createType") > 0) {
				do document.steps.$set("createType",1,"boolean")
			}
			if ($FIND(command,"""columns"":") > 0) {
				do document.steps.$set("columns",1,"boolean")
			}
			if ($FIND(command,"""column"":") > 0) {
				do document.steps.$set("column",1,"boolean")
			}
			if ($FIND(command,"number") > 0) {
				do document.steps.$set("number",1,"boolean")
			}
			if ($FIND(command,"text") > 0) {
				do document.steps.$set("text",1,"boolean")
			}
			
			set sc = col.$upsert(id,document)
			
			if (document.steps.createType && document.steps.columns && document.steps.column && document.steps.number && document.steps.text) {
				do ..LevelUp()
			}
			
		} elseif (level = 6) {
		
			if ($FIND(command,"SELECT") > 0) {
				do document.steps.$set("SELECT",1,"boolean")
			}
			if ($FIND(command,"number") > 0) {
				do document.steps.$set("number",1,"boolean")
			}
			if ($FIND(command,"text") > 0) {
				do document.steps.$set("text",1,"boolean")
			}
			if ($FIND(command,"JSON_TABLE(") > 0) {
				do document.steps.$set("JSON_TABLE",1,"boolean")
			}
			if ($FIND(command,"mathFacts") > 0) {
				do document.steps.$set("collectionName",1,"boolean")
			}
			if ($FIND(command,"%TYPE") > 0) {
				do document.steps.$set("%TYPE",1,"boolean")
			}
			
			set sc = col.$upsert(id,document)
			
			if (document.steps.SELECT && document.steps.number && document.steps.text && document.steps."JSON_TABLE" && document.steps.collectionName && document.steps."%TYPE") {
				do ..LevelUp()
			}
			
		} elseif (level = 7) {
		
			if ($FIND(command,"SELECT") > 0) {
				do document.steps.$set("SELECT",1,"boolean")
			}
			if ($FIND(command,"number") > 0) {
				do document.steps.$set("number",1,"boolean")
			}
			if ($FIND(command,"text") > 0) {
				do document.steps.$set("text",1,"boolean")
			}
			if ($FIND(command,"JSON_TABLE(") > 0) {
				do document.steps.$set("JSON_TABLE",1,"boolean")
			}
			if ($FIND(command,"mathFacts") > 0) {
				do document.steps.$set("collectionName",1,"boolean")
			}
			if ($FIND(command,"%TYPE") > 0) {
				do document.steps.$set("%TYPE",1,"boolean")
			}
			if ($FIND(command,"ORDER BY") > 0) {
				do document.steps.$set("ORDER",1,"boolean")
			}
			
			set sc = col.$upsert(id,document)
			
			if (document.steps.SELECT && document.steps.number && document.steps.text && document.steps."JSON_TABLE" && document.steps.collectionName && document.steps."%TYPE" && document.steps.ORDER) {
				do ..LevelUp()
			}
			
		} elseif (level = 8) {
		
			if ($FIND(command,"SELECT") > 0) {
				do document.steps.$set("SELECT",1,"boolean")
			}
			if ($FIND(command,"number") > 0) {
				do document.steps.$set("number",1,"boolean")
			}
			if ($FIND(command,"text") > 0) {
				do document.steps.$set("text",1,"boolean")
			}
			if ($FIND(command,"JSON_TABLE(") > 0) {
				do document.steps.$set("JSON_TABLE",1,"boolean")
			}
			if ($FIND(command,"mathFacts") > 0) {
				do document.steps.$set("collectionName",1,"boolean")
			}
			if ($FIND(command,"%TYPE") > 0) {
				do document.steps.$set("%TYPE",1,"boolean")
			}
			if ($FIND(command,"WHERE") > 0) {
				do document.steps.$set("WHERE",1,"boolean")
			}
			
			set sc = col.$upsert(id,document)
			
			if (document.steps.SELECT && document.steps.number && document.steps.text && document.steps."JSON_TABLE" && document.steps.collectionName && document.steps."%TYPE" && document.steps.WHERE) {
				do ..LevelUp()
			}
			
		}
		
	} if (stage = 4) {
		
		if (level = 1) {
			
			// nothing to do
			
		} elseif (level = 2) {
			
			if ($FIND(command,"SELECT") > 0) {
				do document.steps.$set("SELECT",1,"boolean")
			}
			if ($FIND(command,"number") > 0) {
				do document.steps.$set("number",1,"boolean")
			}
			if ($FIND(command,"text") > 0) {
				do document.steps.$set("text",1,"boolean")
			}
			if ($FIND(command,"JSON_TABLE(") > 0) {
				do document.steps.$set("JSON_TABLE",1,"boolean")
			}
			if ($FIND(command,"mathFacts") > 0) {
				do document.steps.$set("collectionName",1,"boolean")
			}
			if ($FIND(command,"%TYPE") > 0) {
				do document.steps.$set("%TYPE",1,"boolean")
			}
			if ($FIND(command,"JOIN") > 0) {
				do document.steps.$set("JOIN",1,"boolean")
			}
			if ($FIND(command,"preloaded-Numbers-Trivia-Facts") > 0) {
				do document.steps.$set("collectionName2",1,"boolean")
			}
			
			set sc = col.$upsert(id,document)
			
			if (document.steps.SELECT && document.steps.number && document.steps.text && document.steps."JSON_TABLE" && document.steps.collectionName && document.steps."%TYPE" && document.steps.JOIN && document.steps.collectionName2) {
				do ..LevelUp()
			}
			
		} elseif (level = 3) {
			
			if ($FIND(command,"SELECT") > 0) {
				do document.steps.$set("SELECT",1,"boolean")
			}
			if ($FIND(command,"number") > 0) {
				do document.steps.$set("number",1,"boolean")
			}
			if ($FIND(command,"text") > 0) {
				do document.steps.$set("text",1,"boolean")
			}
			if ($FIND(command,"JSON_TABLE(") > 0) {
				do document.steps.$set("JSON_TABLE",1,"boolean")
			}
			if ($FIND(command,"mathFacts") > 0) {
				do document.steps.$set("collectionName",1,"boolean")
			}
			if ($FIND(command,"%TYPE") > 0) {
				do document.steps.$set("%TYPE",1,"boolean")
			}
			if ($FIND(command,"JOIN") > 0) {
				do document.steps.$set("JOIN",1,"boolean")
			}
			if ($FIND(command,"""number"":") > 0) {
				do document.steps.$set("im-number",1,"boolean")
			}
			if ($FIND(command,"""text"":") > 0) {
				do document.steps.$set("im-text",1,"boolean")
			}
			
			set sc = col.$upsert(id,document)
			
			if (document.steps.SELECT && document.steps.number && document.steps.text && document.steps."JSON_TABLE" && document.steps.collectionName && document.steps."%TYPE" && document.steps.JOIN && document.steps."im-number" && document.steps."im-text") {
				do ..LevelUp()
			}
			
		} elseif (level = 4) {
		
			if ($FIND(command,"SELECT") > 0) {
				do document.steps.$set("SELECT",1,"boolean")
			}
			if ($FIND(command,"TOP") > 0) {
				do document.steps.$set("TOP",1,"boolean")
			}
			if ($FIND(command,"*") > 0) {
				do document.steps.$set("star",1,"boolean")
			}
			if ($FIND(command,"JSON_TABLE(") > 0) {
				do document.steps.$set("JSON_TABLE",1,"boolean")
			}
			if ($FIND(command,"cities") > 0) {
				do document.steps.$set("collectionName",1,"boolean")
			}
			if ($FIND(command,"%TYPE") > 0) {
				do document.steps.$set("%TYPE",1,"boolean")
			}
			if ($FIND(command,"$[*]") > 0) {
				do document.steps.$set("impliedType",1,"boolean")
			}
			
			set sc = col.$upsert(id,document)
			
			if (document.steps.SELECT && document.steps.TOP && document.steps.star && document.steps."JSON_TABLE" && document.steps.collectionName && document.steps."%TYPE" && document.steps.impliedType) {
				do ..LevelUp()
			}
			
		} elseif (level = 5) {
		
			if ($FIND(command,"SELECT") > 0) {
				do document.steps.$set("SELECT",1,"boolean")
			}
			if ($FIND(command,"name") > 0) {
				do document.steps.$set("name",1,"boolean")
			}
			if ($FIND(command,"country") > 0) {
				do document.steps.$set("country",1,"boolean")
			}
			if ($FIND(command,"JSON_TABLE(") > 0) {
				do document.steps.$set("JSON_TABLE",1,"boolean")
			}
			if ($FIND(command,"cities") > 0) {
				do document.steps.$set("collectionName",1,"boolean")
			}
			if ($FIND(command,"COLUMNS") > 0) {
				do document.steps.$set("COLUMNS",1,"boolean")
			}
			if ($FIND(command,"Sample.Person") > 0) {
				do document.steps.$set("Table",1,"boolean")
			}
			if ($FIND(command,"WHERE") > 0) {
				do document.steps.$set("WHERE",1,"boolean")
			}
			if ($FIND(command,"ORDER BY") > 0) {
				do document.steps.$set("ORDER",1,"boolean")
			}
			
			set sc = col.$upsert(id,document)
			
			if (document.steps.SELECT && document.steps.name && document.steps.country && document.steps."JSON_TABLE" && document.steps.collectionName && document.steps.COLUMNS && document.steps.Table && document.steps.WHERE && document.steps.ORDER) {
				do ..LevelUp()
			}
			
		} elseif (level = 6) {
		
			if ($FIND(command,"SELECT") > 0) {
				do document.steps.$set("SELECT",1,"boolean")
			}
			if ($FIND(command,"TOP") > 0) {
				do document.steps.$set("TOP",1,"boolean")
			}
			if ($FIND(command,"JSON_OBJECT") > 0) {
				do document.steps.$set("JSON_OBJECT",1,"boolean")
			}
			if ($FIND(command,"name") > 0) {
				do document.steps.$set("name",1,"boolean")
			}
			if ($FIND(command,"Home_City") > 0) {
				do document.steps.$set("city",1,"boolean")
			}
			if ($FIND(command,"Sample.Person") > 0) {
				do document.steps.$set("Table",1,"boolean")
			}
			
			set sc = col.$upsert(id,document)
			
			if (document.steps.SELECT && document.steps.TOP && document.steps."JSON_OBJECT" && document.steps.name && document.steps."city" && document.steps.Table) {
				do ..LevelUp()
			}
			
		}
		
	}
	
	if (document.commandCount > 4) {
		do ##class(Document.WebSocket).Help(..GetHelpText(stage,level,1))
	}
}

ClassMethod LevelUp()
{
	#dim stage = ^CacheTemp.Experience("stage")
	#dim level = ^CacheTemp.Experience("level")
	
	#dim stage1levelCount = 11
	#dim stage2levelCount = 7
	#dim stage3levelCount = 9
	#dim stage4levelCount = 7
	#dim levelCount = 1
	
	if (stage = 1) {
		
		set levelCount = stage1levelCount
		
	} elseif (stage = 2) {
	
		set levelCount = stage2levelCount
		
	} elseif (stage = 3) {
		
		set levelCount = stage3levelCount
			
	} elseif (stage = 4) {
		
		set levelCount = stage4levelCount
			
	}
	
	if (level < levelCount ) {
	
		do ##class(Document.WebSocket).LevelUp(stage,level+1)
		
	} else {
		
		// advance a stage
		if (stage '= 4) {
			do ##class(Document.WebSocket).LevelUp(stage+1,1)
		}
		
	}
}

/// Checks if the user is stuck at a stage/level and provides some additional 
/// information in case.
ClassMethod CheckHelpConditions()
{
	set ^swi($H,"CheckHelpConditions") = ""
	#dim db = ##class(%DataModel.Document.Database).$getDatabase()
	#dim stage = ^CacheTemp.Experience("stage")
	#dim level = ^CacheTemp.Experience("level")
	#dim id = stage_"-"_level
	
	#dim col = db.$getCollection("doNotTouch-Stats")
	#dim document = col.$get(id)
	
	if (document) {
		
		set document.errorCount = document.errorCount + 1
		do col.$upsert(id,document)
		
	} else {
		
		set document = {"errorCount":1,"shownHelp":false}
		set sc = col.$insertAt(id,document)
		
	}
	
	if ((document.errorCount#3 = 0) && 'document.shownHelp) {
		
		do ##class(Document.WebSocket).Help(..GetHelpText(stage,level))
		
		do document.$set("shownHelp",1,"boolean")
		do col.$upsert(id,document)
	}
}

/// Return a help text for a given stage and level
ClassMethod GetHelpText(stage, level, good = 0)
{
	#dim message = "Hey, don't panic if things go wrong. Just raise your hand and our staff will help you out.</br></br>"
	
	if (good) { set message = "" }
	
	if (stage = 1) {
	
		if (level = 1) {
			// no error possible here
		} elseif (level = 2) {
			set message = message _ "Did you know you can copy the command <pre>set db = ##class(%DataModel.Document.Database).$getDatabase()</pre> from the assignment area to the terminal? This way you can ensure you got the syntax correct."
		} elseif (level = 3) {
			set message = message _ "Try executing: <pre>write db.databaseCollection.$size()</pre>"
		} elseif (level = 4) {
			set message = message _ "Try executing: <pre>do ##class(Document.Help).ListCollections()</pre>"
		}
		
	}
	
	return message
}

}
