This lab provides experience what it means to work with schema-less data.

Discover the power of documents and what makes the InterSystems’ approach unique.
Work on your own machine without installing anything. 

After this experience, you will be able to query any JSON-like data. Happy coding!

#Install

1. Import the classes into a new namespace „GS“
2. Map the package „Sample“ from the „SAMPLES“ namespace to the „GS“ namespace
3. Map the globals „Sample.Person.*“ from the „SAMPLES“ namespace to the „GS“ namespace
4. Load the contents of the cities collection by executing
  
  `write ##class(Document.Loader).loadCities("<path to the directory where the cities-en.json file is stored; with a trailing slash>")`

5. Create `Default` client SSL configuration
6. Load the contents of the math collections by executing `write ##class(Document.Loader).PreLoad()`
7. Start the experience by opening the following URL in your browser:

    `http://<ip of your Caché server>:<port of your Caché instance>/csp/gs/Document.UI.Start.cls`
