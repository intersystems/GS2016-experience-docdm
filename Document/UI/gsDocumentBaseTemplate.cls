Class Document.UI.gsDocumentBaseTemplate Extends %ZEN.Mojo.Component.contentTemplate [ ProcedureBlock ]
{

Parameter DOMAIN = "GS Document Experience";

Parameter NAMESPACE = "http://www.intersystems.com/zen/mojo/Global Summit - Document Data Model Experience";

ClientMethod buildAdvanceButton(caption) [ Language = javascript ]
{
	return ('<button onclick="zenPage.getTemplate().advanceLevel();$(this).remove();" class="btn btn-default">'+caption+'</button>');
}

ClientMethod buildAdvanceStageButton(caption) [ Language = javascript ]
{
	return ('<button onclick="zenPage.getTemplate().advanceStage(\'terminal\');$(this).remove();" class="btn btn-default">'+caption+'</button>');
}

ClientMethod buildGotoButton(stage, level, caption) [ Language = javascript ]
{
	return ('<button onclick="zenPage.getTemplate().gotoStageLevel('+stage+','+level+');$(this).remove();" class="btn btn-default">'+caption+'</button>');
}

ClientMethod getData(key, criteria) [ Language = javascript ]
{
	var data = {messages:[]};
	var template = zenPage.getTemplate();
	
	var startTerminalButton = '<button onclick="zenPage.getTemplate().advanceLevel(\'terminal\');$(this).remove();" class="btn btn-default">Let\'s get started</button>';
	var advanceButton = template.buildAdvanceButton('Got it. Next step please.');
	var advanceStageButton = template.buildAdvanceStageButton('Cheat - Move to next stage');
	
	var taskDone = '<span class="glyphicon glyphicon-ok" aria-hidden="true"></span></br>';
	
	switch (key) {
	
		case 'stage1':
		
			data.messages.push(
				{level:1,message:'<h3>Welcome to the Document Data Model Experience!</h3>This Experience will guide you through some basic and unique tasks you can achieve with the document data model. Let\'s get started with stage 1!</br></br>'+startTerminalButton}
			);
			
			data.messages.push(
				{level:2,message:'<h3>Getting started</h3>Let\'s start by getting a handle to the document database. The database handle allows you to interact with collections that are accessible in the current namespace.</p><pre>set db = ##class(%DataModel.Document.Database).$getDatabase()</pre>'}
			);
			
			data.messages.push(
				{level:3,message:'<h3>Exploration - Count Collections</h3>You did it! One of the first things you want to do is explore the environment. Let\'s check how many collections are available. The database handle has a property <code>databaseCollection</code> that refers to the system collection that contains the definition of all collections. Just call the method $size() on it:</p><pre>write db.databaseCollection.$size()</pre>'}
			);
			
			data.messages.push(
				{level:4,message:'<h3>Exploration - List Collections</h3>That\'s the spirit. Now we know that there are a couple of collections. As a next step, you want to list the names of the available collections.</p>Let\'s get an iterator back from the databaseCollection property and iterate over the collection metadata:</p><pre>set iter = db.databaseCollection.$getIterator()</br>while iter.$getNext(.collectionID) {</br>\twrite db.databaseCollection.$get(collectionID).name,!</br>}</pre>In case you don\'t want to type so much code, you can also call a helper method that does exactly the same thing: </p><pre>do ##class(Document.Help).ListCollections()</pre>'}
			);
			
			data.messages.push(
				{level:5,message:'<h3>Exploration - List Collections</h3>Very good. <code>syscollections</code> and <code>sysindexes</code> are system collections, so we do not want to touch them. <code>doNotTouch-Stats</code> is the place where this application is doing some housekeeping, e.g. where you are at the moment, which commands you executed and more.</p>The collections <code>preloaded-Numbers-Math-Facts</code> and <code>preloaded-Numbers-Trivia-Facts</code> have been preloaded with data from an online REST API and we want to fetch data from them over REST and store it in a new collection. We have done this to ensure we don\'t overwhelm the conference WiFi.</p>'+advanceButton}
			);
			
			data.messages.push(
				{level:6,message:'<h3>Exploration - Retrieve a collection</h3>Let\'s take a look at one of the collections. You can retrieve the <code>preloaded-Numbers-Math-Facts</code> collection by calling the <code>$getCollection(&lt;collectionName&gt;)</code> on the database handle and pass in the collection name <code>preloaded-Numbers-Math-Facts</code> as an argument:</p><pre>set preloadedMathFacts = db.$getCollection("preloaded-Numbers-Math-Facts")</pre>'}
			);
			
			data.messages.push(
				{level:7,message:'<h3>Exploration - Count Documents</h3>Find out how many documents are persisted in this collection by calling the method <code>$size()</code> on the collection:</p><pre>write preloadedMathFacts.$size()</pre>'}
			)
			
			data.messages.push(
				{level:8,message:'<h3>Exploration - Retrieve a document</h3>Retrieving a document from a collection is as easy as calling <code>$get(&lt;document-id&gt;)</code> on the collection handle. The id range for this collection is currently 1 - 10.</p>Let\'s retrieve a random document:</p><pre>set document = preloadedMathFacts.$get(1)</pre>'}
			)
			
			data.messages.push(
				{level:9,message:'<h3>Exploration - Serialize a document to JSON</h3>Once you have received a document you can easily introspect it. A simple way is to serialize it to JSON by calling <code>$toJSON()</code> on the document:</p><pre>write document.$toJSON()</pre>'}
			)
			
			data.messages.push(
				{level:10,message:'<h3>Exploration - Retrieve a specific value</h3>Serializing a document as JSON is a quick way to inspect the content of the whole document. You can programmatically access the value for each key by accessing them directly as properties, for example:</p><pre>write document.number</pre>An alternative way is to use the getter method <code>$get(&lt;key-name&gt;)</code>, just pass in the name of the key you want to access as the first argument. Try to retrieve the value of the key <code>text</code>:</p><pre>write document.text</pre>'}
			)
			
			data.messages.push(
				{level:11,message:'<h3>Exploration - Accomplished</h3>You have done a great job. You have learned the very basics of data retrieval in the document data model. Obviously there is much more to learn, but this is a good start. Let\'s go a step further and take a look at importing data from another source.</p>'+template.buildAdvanceButton('Unlock stage 2')}
			);
		
			break;
			
		case 'stage2':
		
			data.messages.push(
				{level:1,message:'<h3>Data Retrieval over REST</h3>Let\'s start by requesting all documents stored in the <code>preloaded-Numbers-Math-Facts</code> collection over REST. The document data model comes with a REST API, so we can issue a GET request to </p><pre>http:\/\/&lt;ip&gt;:&lt;port&gt;\/api\/document\/v1\/&lt;namespace&gt;\/&lt;collectionName&gt;</pre>in order to retrieve the contents of a collection.</br>You can make a GET request very easy with a helper method that is available during this exercise:</p><pre>set import = ##class(Document.Help).FromURI("http:\/\/'+zenPage.serverIP+':'+zenPage.serverPort+'\/api\/document\/v1\/gs\/preloaded-Numbers-Math-Facts")</pre>Please note that we already inserted the correct local IP-address and port number into the target URL string.'}
			);
		
			data.messages.push(
				{level:2,message:'<h3>Data Inspection</h3>Very good. Inspecting the return value is the first thing you should be doing. Serialize the <code>import</code> object to JSON by calling the <code>$toJSON</code> method:</p><pre>write import.$toJSON()</pre>'}
			);
			
			data.messages.push(
				{level:3,message:'<h3>Data Ingestion - Part 1</h3>You can observe, that the return object has three top level properties: <ul><li>collection</li><li>size</li><li>content</li></ul><code>collection</code> contains the name of the collection we requested the data from,<code>size</code> reports the number of documents that are stored in the remote collection and <code>content</code> actually holds an array of all documents. There are other ways to transport huge collections in chunks, but right now one big array is exactly what we want.</p>The next step is to insert the documents from the <code>content</code> property into a new collection. Therefore you have to get a handle for a new collection. Let\'s call this collection <code>mathFacts</code>.</p><pre>set mathFacts = db.$getCollection("mathFacts")</pre>'}
			);
			
			data.messages.push(
				{level:4,message:'<h3>Data Ingestion - Part 2</h3>Now that we have requested the data via REST and got a handle to our new collection we can actually insert the data. If you want to insert a single document you can call the method <code>$insert(&lt;document&gt;)</code> on your collection.</p>In our case we actually have an array of documents we want to store. Passing <code>import.content</code> to a <code>$insert()</code> call would store a single document that is an array.</p>Also, you can see that each document is wrapped with header information, which contains the ID and the document version from the collection we extrated the data from. Therefore, we want to iterate over <code>import.content</code>, retrieve the previous id and upsert (insert or update) each document individually.</p>We have prepared a helper method, that does exactly this:</p><pre>do ##class(Document.Help).Import(mathFacts,import)</pre></p>In case you are interested, this is what the method does:</p><pre>ClassMethod Import(collection, data) {</br>\tset iter = data.content.$getIterator()</br>\twhile iter.$getNext(.key,.document) {</br>\t\tset status = collection.$upsert(document.documentID,document.content)</br>\t}</br>}</pre>'}
			);
			
			data.messages.push(
				{level:5,message:'<h3>Check the new collection</h3>Verify that your <code>mathFacts</code> collection now holds 10 documents (one document for each number ranging from 1 to 10). You can do this by calling the method <code>$size()</code> on your collection:</p><pre>write mathFacts.$size()</pre>'}
			);
			
			data.messages.push(
				{level:6,message:'<h3>Final check</h3>Excellent. As a final check you can retrieve a document and serialize it to JSON. Most methods allow chaining, so you can do this in a single statement, e.g.:</p><pre>write mathFacts.$get(3).$toJSON()</pre>'}
			);
			
			data.messages.push(
				{level:7,message:'<h3>Data Ingestion - Accomplished</h3>Great job. You did import data over REST, stored it in a local collection and did some inspection, similar to the previous stage. And all of this in six simple steps.</p>The next stage will cover SQL queries over collections.</p>'+template.buildAdvanceButton('Unlock stage 3')}
			);
		
			break;
			
		case 'stage3':
		
			data.messages.push(
				{level:1,message:'<h3>SQL queries - Querying a collection</h3>So far you have seen a couple of basic operations that are supported by various vendors in the market place. As a next step we want you to experience something unique. We are going to run some SQL queries. And we will be querying documents stored in collections. Data without a static schema. </p>Switch to SQL mode by executing </p><pre>/sql</pre></p>'+advanceButton}
			);
			
			data.messages.push(
				{level:2,message:'<h3>Introducing JSON_TABLE</h3>As a collection does not provide a static schema, like a table does, you have to provide some information how documents are supposed to be mapped to columns. The JSON_TABLE function is going to provide you the tools you need for this task. The JSON_TABLE function takes two arguments: </p><ol><li>a data source</li><li>a mapping from document values to columns</li></ol></p>It is easiest to start with an example:</p><pre>SELECT COUNT(*) FROM JSON_TABLE(\'mathFacts\', \'$\' COLUMNS(number INT PATH \'$.number\'))</pre>The first argument is the name of the collection we want to query: <code>mathFacts</code>. Don\'t think too much about the second argument. We will cover it in the next step.</p>For now, execute the above query and see what it does. It should return the count of your documents in the collection <code>mathFacts</code>: 10'}
			);
			
			data.messages.push(
				{level:3,message:'<h3>JSON_TABLE and the COLUMNS clause</h3></p>Wonderful. As a next step we will actually select a column, instead of asking for the count of records:</p><pre>SELECT number FROM JSON_TABLE(\'mathFacts\', \'$\' COLUMNS(number INT PATH \'$.number\'))</pre> Let\'s explore the second argument a little bit further. It sets the context of the COLUMNS clause to the root of the document by specifying "$". The expression "$" has a special meaning, it points to the root of the current context.</p>The COLUMNS clause follows afterwards. It is a comma-separated list of columns. Each column definition consists of a name, a type and a PATH which evaluates to the value of each row for this column. So this COLUMNS clause defines one COLUMN named \'number\', with the type INT and the value will be extracted from the top-level key \'number\' from each document.</p>Execute the above SQL statement.'}
			);
			
			data.messages.push(
				{level:4,message:'<h3>JSON_TABLE and the COLUMNS clause</h3></p>That\'s it. As a next step, we will extract the text property as well:</p><pre>SELECT number, text FROM JSON_TABLE(\'mathFacts\', \'$\' COLUMNS(number INT PATH \'$.number\', text VARCHAR(100) PATH \'$.text\'))</pre>As you can see, we have added a second COLUMN expression to the COLUMNS clause. We are mapping the top-level key \'text\' to a COLUMN \'text\' with the type VARCHAR(100).</p>Execute the above SQL statement.'}
			);
			
			data.messages.push(
				{level:5,message:'<h3>JSON_TABLE and types</h3>Very good.</p>You may have noticed that the COLUMNS expression can be quite verbose. The information it contains is always required in order to be able to create the virtual table, but there is a way to store COLUMN expressions that are often used and shared by multiple queries as in our case.</p>Let\'s store the COLUMNS expression we have been using so far.</p>For this exit the SQL mode by executing </p><pre>/sql</pre></p>The database object provides an API call to persist type information, the method is called <code>$createType(arg1,arg2)</code>. The first argument is the unique identifier for a type information. The second identifier is a dynamic object that is containing the same information as the COLUMNS clause in SQL queries. Execute the following command:</p><pre>do db.$createType("numbersAndText",{"columns":[{"column":"number","path":"$.number","type":"INT"},{"column":"text","path":"$.text","type":"VARCHAR(100)"}]})</pre>'}
			);
			
			data.messages.push(
				{level:6,message:'<h3>Using a type in JSON_TABLE</h3>Good job. Switch back to SQL mode by executing </p><pre>/sql</pre>Now that we have created and stored a type information we can start using it in our queries. Instead of providing a COLUMNS clause you are using the %TYPE keyword followed by the identifier of the type information you want to use:</p><pre>SELECT number, text FROM JSON_TABLE(\'mathFacts\', \'$\' %TYPE \'numbersAndText\')</pre>Execute the above SQL statement and make sure that you get the same result back as in the previous exercise, just with a less verbose and more concise query!'}
			);
			
			data.messages.push(
				{level:7,message:'<h3>JSON_TABLE and SQL</h3>You have seen so far that JSON_TABLE constructs a virtual table that can be queried in a FROM clause. One advantage of this approach is that all exposed columns are accessible in the SQL query - obviously, otherwise you wouldn\'t be able to select the columns in your SELECT clause.</p> This also means that you can order the result set based on your document data:</p><pre>SELECT number, text FROM JSON_TABLE(\'mathFacts\', \'$\' %TYPE \'numbersAndText\') ORDER BY number DESC</pre>Execute the above query and observe the altered order.'}
			);
			
			data.messages.push(
				{level:8,message:'<h3>JSON_TABLE and SQL</h3>You are getting the idea. Let\'s try to restrict the result set to all numbers above 5:</p><pre>SELECT number, text FROM JSON_TABLE(\'mathFacts\', \'$\' %TYPE \'numbersAndText\') WHERE number &gt; 5</pre>Execute the above query. You should only get 5 results back in default order (ascending).'}
			);
			
			data.messages.push(
				{level:9,message:'<h3>Querying collections with SQL - Accomplished</h3>Congratulations! You completed stage 3 and executed some basic SQL queries that did query documents which are persisted in collections. This is a unique capability in the market, which allows you to build flexible and agile applications and still leverage the power of SQL.</p>Are you interested to see some more advanced SQL techniques you can make use of? Then continue with the last stage.</p>'+template.buildAdvanceButton('Unlock stage 4')}
			);
			
			break;
			
		case 'stage4':
		
			data.messages.push(
				{level:1,message:'<h3>Advanced SQL queries</h3>Welcome to the last stage of this Experience. In this stage we want to take a look at more advanced SQL techniques.</p>'+advanceButton}
			);
			
			data.messages.push(
				{level:2,message:'<h3>Joining two collections</h3>Joining two collections is something pure document stores struggle with. As the output of the JSON_TABLE function is a virtual table, you can easily join multiple collections with each other.</p>This makes the document data model very effective, you don\'t have to duplicate data, instead you can query just the data you need. Our engine supports indices, which can be leveraged by the SQL runtime, which ensures this approach is performing well. All indices are bitmap indices by default and bitmap operations are very efficient.</p>In case you are not in SQL mode, switch to SQL mode by entering <code>/sql</code>.</p>In this exercise we want to join the collection <code>mathFacts</code> with the preloaded collection <code>preloaded-Math-Trivia-Facts</code>.</p>We can achieve this by joining two JSON_TABLE functions:</p><pre>SELECT a.number, a.text, b.text FROM JSON_TABLE(\'mathFacts\', \'$\' %TYPE \'numbersAndText\') as a LEFT OUTER JOIN JSON_TABLE(\'preloaded-Numbers-Trivia-Facts\', \'$\' %TYPE \'numbersAndText\') as b ON a.number = b.number </pre>Execute the above statement.'}
			);
			
			data.messages.push(
				{level:3,message:'<h3>Query in-memory JSON</h3>That\'s it. There is no limit to the number of collections you can join. This approach allows you to import data from multiple sources and join the data seamlessly.</p>In addition JSON_TABLE does also support querying of in-memory JSON data. Just provide literal JSON as the first argument to the JSON_TABLE function, instead of a collection name:</p><pre>SELECT a.number, a.text, b.text FROM JSON_TABLE(\'mathFacts\', \'$\' %TYPE \'numbersAndText\') as a RIGHT OUTER JOIN JSON_TABLE(\'[{"number":1,"text":"This is number 1"},{"number":5,"text":"Short Circuit"}]\', \'$\' %TYPE \'numbersAndText\') as b ON a.number = b.number</pre>Instead of joining with the <code>preloaded-Numbers-Trivia-Facts</code> we are now joining with in-memory data that shares the same structure, so that we can leverage the same type information. Note that the JOIN is now a RIGHT OUTER JOIN. This way the result does not include NULL values on the right side of our JOIN (our in-memory structure).</p>Run the above statement.'}
			);
						
			data.messages.push(
				{level:4,message:'<h3>Query an unknown collection</h3>The last set of instructions will operate on more complex data that is provided in the SAMPLES namespace. We have mapped the data to this namespace, so you don\'t have to worry. The next step involves a collection with a more complex schema. Therefore we want to explore the structure of the collection <code>cities</code> first. The <code>%TYPE</code> keyword also supports an implied type, which will map all top-level keys to columns. The implied type can be used by specifying <code>\'$[*]\'</code> after <code>%TYPE</code>.</p>Let\'s try this:</p><pre>SELECT TOP 10 * FROM JSON_TABLE(\'cities\', \'$\' %TYPE \'$[*]\')</pre>Execute the above statement and explore the available columns of the result set.</p><b>Note:</b> The implied type is not meant for production use, but instead it can be used to explore collections you are unfamiliar with. A specific mapping, either with a COLUMNS expression, or a stored type information is recommended for production-ready SQL.'}
			);
			
			data.messages.push(
				{level:5,message:'<h3>Join a table with a collection</h3>Well done! You may have observed, that the <code>cities</code> collection includes a city name and the corresponding country code. We want to join this collection with the table <code>Sample.Person</code>. The table defines a column <code>Home_City</code>. This allows us to join each record with a document from the <code>cities</code> collection if the city name is equal. As a benefit we can add country code information and even restrict the result set to all people who live in the US:</p><pre>SELECT p.%ID, p.name, c.name, c.country FROM JSON_TABLE(\'cities\',\'$\' COLUMNS(name VARCHAR(50) PATH \'$.name\',country VARCHAR(50) PATH \'$.country\')) as c, Sample.Person as p WHERE p.Home_City = c.name AND c.country = \'US\' ORDER BY c.name ASC</pre>Execute the above statement.'}
			);
			
			data.messages.push(
				{level:6,message:'<h3>Produce JSON from a table</h3>The capability to join a table with a collection enables very powerful use cases. As an example you can easily import public data from a REST API and enrich your current data, which may be stored in tables. You have seen everything you need for this during this Experience.</p>There is one more capability to explore: Producing JSON from tables. This can be used to import relational data to the document data model or to expose table data in JSON format via REST.</p><code>JSON_OBJECT</code> is a function that produces a JSON object for each row, while <code>JSON_ARRAY</code> produces an array. Let\'s take a look at an example:</p><pre>SELECT TOP 10 JSON_OBJECT(\'name\' : name, \'city\' : Home_City) FROM Sample.Person</pre>The above statement selects the first ten records from the table <code>Sample.Person</code> and produces a JSON object with two keys: <code>name</code> and <code>city</code>. The values are filled with the value of the corresponsing <code>name</code> and <code>Home_City</code> columns.'}
			);			
			
			data.messages.push(
				{level:7,message:'<h3>You did it!</h3>This marks the end of this Experience.</p>You have explored a complete new data model and seen some of the differentiators that make this model unique:</p><ul><li>Documents are stored in flexible collections</li><li>Collections can be queried via SQL according to the SQL standard</li><li>Collections can be joined with tables, allowing easy integration in existing applications</li><li>Tables can be queried to produce JSON data</li><li>Type information can be stored for modular coding</li></ul></p>We are very excited about these new capabilites. Let us know what you think about it!</p><h4>What now?</h4>If you are interested to learn more about what you just learned, make sure to attend the related Document Data Model Sessions</p><ul><li>The Power of Handling Data Without a Schema</li><li>Modern Full-Stack Development</li><li>Keep Your Application Agile</li></ul>Take a look at the content hosted on our Learning Service Portal: <a href="http://learning.intersystems.com" target="_blank">learning.intersystems.com</a> This Experience will also be hosted there after the Global Summit.</p>Make sure to say hello to the team behind the Document Data Model, you can find us at the developer zone or contact us via the slack channel.'}
			);
			
			break;		
	}
	
	
	// add cheat button
	if (zenPage.developerMode && zenPage.stage != 4) {
		
		data.messages[0].message = data.messages[0].message + '</br>' + advanceStageButton;
		
	}
	
	// add resume button, in case someone had to restart
	if (localStorage && zenPage.stage == 1 && zenPage.level == 1) {
	
		var stage = localStorage.getItem('stage');
		var level = localStorage.getItem('level');
		
		if (stage && level) {
			
			var gotoButton = template.buildGotoButton(stage,level,'Had to restart? Resume here.');
			data.messages[0].message = data.messages[0].message + '</br>' + gotoButton;
			
		}
		
	}
	
	return data;
}

/// Creates the layout object for the page
ClientMethod getLayout(key, criteria) [ Language = javascript ]
{
 	var layout = {};
 	switch(key) { 
 		case 'stage1' : 
  			// add layout objects to the children array
			layout = {
				children:[
					{type:'$div',cssClass:'headerDiv navbar-fixed-top',children:[
						{type:'$content',cssClass:'header',content:'Document Data Model Experience'}
					]},
					{type:'$div',key:'mainDiv',cssClass:'mainDiv',children:[
					{type:'$div',cssClass:'progress',children:[
					    {type:'$progressBar',key:'progress-stage-1',theme:'success',value:'0'},
					    {type:'$progressBar',key:'progress-stage-2',theme:'info',value:'0'},
					    {type:'$progressBar',key:'progress-stage-3',value:'0'},
					    {type:'$progressBar',key:'progress-stage-4',theme:'success',value:'0'}
					]},
						{type:'$gridSystem',id:'grid',children:[
					        {type:'$gridColumn',key:'left-grid',md:'6',children:[
					            // contains assignments and help
					            //{type:'$glyphicon',icon:'alert'},
					            {type:'$h1',ovSize:'2',content:'Assignments'},
					            {type:'$div',key:'messageDiv',cssClass:'messageDiv',value:'=[messages]',children:[
					            	{type:'$if',value:'=[level]',expectedValue:1,children:[
					            		{type:'$content',key:'message',cssClass:'message old',content:'=[message]'}
					            	]}
					            ]},
					            {type:'$div',key:'help-modal'}
					        ]},
					        {type:'$gridColumn',key:'right-grid',md:'6',children:[
					            // contains your work space // terminal
					            {type:'$h1',ovSize:'2',content:'Workspace'},
					            {type:'$iframe',cssClass:'hidden',key:'workspace'/*src:'/terminal/'*/,width:'90%',height:'300px'}
					        ]}
					    ]}
					]}
				]
 			}; 
			break;
 	} 

 	return layout;
}

/// Client-side content provider method.
/// <var>providerName</var> is the name of the json provider. 
/// <var>key</var> is the key value associated with the request.
/// <var>criteria</var> is the search criteria associated with the request.
ClientMethod onGetContent(providerName, key, criteria) [ Language = javascript ]
{
 	switch (providerName)
 	{ 
 		case 'layout': 
  			return this.getLayout(key,criteria);
  		case 'data':
  			return this.getData(key,criteria);
 	} 

 	// return null -> fetch data from server (if local cache is empty)
 	return null;
}

ClientMethod onchange(key, value, final, docViewId) [ Language = javascript ]
{
	//console.log('change ' + key + ' to ' + value);
 	var view = zen(docViewId);
 	switch(key) {
 	}
}

ClientMethod onselect(key, value, docViewId) [ Language = javascript ]
{
	//console.log('select '+key);
 	var view = zen(docViewId);
 	var realKey = key.split(':')[0];
 	switch(realKey) {	 	
 	}
}

/// advances to a specific stage and level. This
/// method is used in case of recovery
ClientMethod gotoStageLevel(stage, level) [ Language = javascript ]
{

	zenPage.stage = stage;
	zenPage.level = level;
	
	zen('mainView').setDocumentKey('stage'+zenPage.stage);
	zen('mainView').getSourceData();
	this.sendStageLevel();
	this.updateMessages();
	this.updateWorkspace('terminal','');
	this.updateProgress();
}

/// advances to the next stage and reveals a new view
/// TODO
ClientMethod advanceStage(show, hide) [ Language = javascript ]
{
	zenPage.stage++;
	zenPage.level = 1;
	zen('mainView').setDocumentKey('stage'+zenPage.stage);
	zen('mainView').getSourceData();
	this.sendStageLevel();
	this.updateMessages();
	this.updateWorkspace(show,hide);
	this.updateProgress();
}

/// advances to the next level and reveals the messages that are
/// tied to that level.
ClientMethod advanceLevel(show, hide) [ Language = javascript ]
{
	var data = zen('mainView').getSourceData();
	if (data.messages[data.messages.length-1].level == zenPage.level) {
		// we have to advance a stage
		this.advanceStage(show,hide);
		return;
	}
	
	zenPage.level++;
	this.sendStageLevel();
	this.updateMessages();
	this.updateWorkspace(show,hide);
	this.updateProgress();
}

ClientMethod decreaseLevel(show, hide) [ Language = javascript ]
{
	var hide = hide;
	if (zenPage.level > 1) {
		zenPage.level--;
		if (zenPage.stage == 1 && zenPage.level == 1) {
			hide = "terminal";
		}
		this.sendStageLevel();
		this.updateMessages();
		this.updateWorkspace(show,hide);
		this.updateProgress();
	}
}

ClientMethod updateMessages() [ Language = javascript ]
{
	var view = zen('mainView');
	var data = view.getSourceData();
		
	var msgDiv = $(".messageDiv")[0];
	msgDiv.innerHTML="";
	
	var html = [];
	for (var i = 0; i < data.messages.length; i++) {
		var message = view.getItemByKey('message:'+(i));
		if (zenPage.level === data.messages[i].level) {
			html.push('<div class="message new">'+data.messages[i].message+'</div>');
		}
	}
	if (zenPage.level > 1) {
	
		html.push('<button onclick="zenPage.getTemplate().decreaseLevel();" class="btn btn-default">Go back a step</button>');
		
	}
	
	// TODO: allow to jump back a stage?
		
	msgDiv.innerHTML=html.join();
	
	setTimeout(function() {
		var messages = $(".new");
		
		for (var i = 0; i < messages.length; i++) {
			messages[i].className = "message old";
		}
	},10);
}

ClientMethod updateWorkspace(show, hide) [ Language = javascript ]
{
	var view = zen('mainView');
	
	switch (show) {
	
		case 'terminal':
		
			var wsDiv = view.getItemByKey('workspace').$findElement();
			wsDiv.src = '/terminal/';
			wsDiv.className='shown';
		
			break;
			
		case 'smp-sql':
		
			// todo? maybe - maybe not ;)
			
			break;
		
	}
	
	switch (hide) {
		
		case 'terminal':
		
			var wsDiv = view.getItemByKey('workspace').$findElement();
			wsDiv.src = '';
			wsDiv.className='shown';
		
			break;
			
		case 'smp-sql':
		
			// todo? maybe - maybe not ;)
			
			break;
		
	}
}

ClientMethod updateProgress() [ Language = javascript ]
{
	var view = zen('mainView');
	
	var progress1 = view.getItemByKey('progress-stage-1');
	var progress2 = view.getItemByKey('progress-stage-2');
	var progress3 = view.getItemByKey('progress-stage-3');
	var progress4 = view.getItemByKey('progress-stage-4');
	
	var msg1 = zenPage.getContent('data','stage1',{}).messages;
	var msg2 = zenPage.getContent('data','stage2',{}).messages;
	var msg3 = zenPage.getContent('data','stage3',{}).messages;
	var msg4 = zenPage.getContent('data','stage4',{}).messages;
	
	var msg1LevelCount = msg1[msg1.length-1].level;
	var msg2LevelCount = msg2[msg2.length-1].level;
	var msg3LevelCount = msg3[msg3.length-1].level;
	var msg4LevelCount = msg4[msg4.length-1].level;
	var totalLevelCount = msg1LevelCount + msg2LevelCount + msg3LevelCount + msg4LevelCount;
	
	switch (zenPage.stage) {
		
		case "1":
		case 1:
			progress1.value = (zenPage.level-1) / totalLevelCount * 100;
			progress2.value = 0;
			progress3.value = 0;
			progress4.value = 0;
			break;
		case "2":
		case 2:
			progress1.value = msg1LevelCount /totalLevelCount * 100;
			progress2.value = (zenPage.level-1) / totalLevelCount * 100;
			progress3.value = 0;
			progress4.value = 0;
			break;
		case "3":
		case 3:
			progress1.value = msg1LevelCount / totalLevelCount * 100;
			progress2.value = msg2LevelCount / totalLevelCount * 100;
			progress3.value = (zenPage.level-1) / totalLevelCount * 100;
			progress4.value = 0;
			break;
		case "4":
		case 4:
			progress1.value = msg1LevelCount / totalLevelCount * 100;
			progress2.value = msg2LevelCount / totalLevelCount * 100;
			progress3.value = msg3LevelCount / totalLevelCount * 100;
			progress4.value = (zenPage.level-1) / totalLevelCount * 100;;
			break;
	}
	
	//console.log(progress1.value + ' ' + progress2.value + ' ' + progress3.value);
	
	progress1.$findElement().style = "width:"+progress1.value+"%;";
	progress1.$findElement().setAttribute("aria-valuenow",progress1.value);
	progress2.$findElement().style = "width:"+progress2.value+"%;";
	progress2.$findElement().setAttribute("aria-valuenow",progress2.value);
	progress3.$findElement().style = "width:"+progress3.value+"%;";
	progress3.$findElement().setAttribute("aria-valuenow",progress3.value);
	progress4.$findElement().style = "width:"+progress4.value+"%;";
	progress4.$findElement().setAttribute("aria-valuenow",progress4.value);
}

ClientMethod startWebSocket() [ Language = javascript ]
{
	ws = new WebSocket(((window.location.protocol == "https:") ? "wss:" : "ws:") + "//" + window.location.host + "/csp/gs/Document.WebSocket.cls");
    zenPage._ws = ws;
    
	ws.onopen = function(event) {
		// connection opened
		//console.log("WebSocket opened");
	};

	ws.onmessage = function(event) {
		// received a message from the server
		var d=JSON.parse(event.data);
		var view = zen('mainView');

		if (d.type=="LevelUp") {
		 	//console.log("New stage-level: " + d.stage + '-' + d.level);
		 	if (d.stage == zenPage.stage) {
		 		zenPage.getTemplate().advanceLevel();
		 	} else {
			 	zenPage.getTemplate().advanceStage();
		 	}
		} else if(d.type=="EchoCommand") {
			console.info("Typed: " + d.command);
		} else if (d.type=="Help") {
			zenPage.getTemplate().createHelpModal("Need help?",d.message);
		}
	};

	ws.onerror = function(event) { alert("Received WS error"); };

	ws.onclose = function(event) {
		// connection closed
	    ws = null;
	    zenPage._ws = null;
	  	//console.log("WebSocket closed");
	}
}

ClientMethod sendStageLevel() [ Language = javascript ]
{
	if (localStorage) {
		localStorage.setItem('stage',zenPage.stage);
		localStorage.setItem('level',zenPage.level);	
	}
	
	if (zenPage._ws === null || typeof(zenPage._ws) === "undefined") {
		this.startWebSocket();
	}
	
	var ws = zenPage._ws;
	
	var data = {"type":"update","stage":zenPage.stage,"level":zenPage.level};
	
	ws.send(JSON.stringify(data));
}

ClientMethod createHelpModal(heading, formContent) [ Language = javascript ]
{
    html =  '<div id="dynamicModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="confirm-modal" aria-hidden="true">';
    html += '<div class="modal-dialog">';
    html += '<div class="modal-content">';
    html += '<div class="modal-header">';
    html += '<a class="close" data-dismiss="modal">?</a>';
    html += '<h4>'+heading+'</h4>'
    html += '</div>';
    html += '<div class="modal-body">';
    html += '<p>';
    html += formContent;
    html += '</div>';
    html += '<div class="modal-footer">';
    html += '<span class="btn btn-primary" data-dismiss="modal">Close</span>';
    html += '</div>';  // content
    html += '</div>';  // dialog
    html += '</div>';  // footer
    html += '</div>';  // modalWindow
    $('body').append(html);
    $("#dynamicModal").modal();
    $("#dynamicModal").modal('show');

    $('#dynamicModal').on('hidden.bs.modal', function (e) {
        $(this).remove();
    });
}

}
