Class Document.UI.Start Extends %ZEN.Mojo.basePage [ ProcedureBlock ]
{

/// Class name of application this page belongs to.
/// This is set by the %OnCreateApplication method.
Parameter APPLICATION = "Document.UI.Application";

Parameter DOMAIN = "GS Document Experience";

Parameter CSSINCLUDES = "bootstrap-3-3-5/dist/css/bootstrap.min.css";

Parameter JSINCLUDES = "jquery-1.11.3.min.js,bootstrap-3-3-5/dist/js/bootstrap.min.js";

Parameter NAMESPACE = "http://www.intersystems.com/zen/mojo/Global Summit - Document Data Model Experience";

/// If true, then attempt to refresh this page when its session timeout period has expired.
/// This will cause a login page to display if the current session has ended
/// and security is set to require login.
Parameter AUTOLOGOUT As BOOLEAN = 1;

Parameter PAGENAME = "Global Summit - Document Data Model Experience";

Parameter PROVIDERLIST = "data,layout";

/// If true, only show the core content.
Property embedded As %ZEN.Datatype.boolean(ZENURL = "EMBED") [ InitialExpression = 1 ];

Parameter TEMPLATECLASS = "Document.UI.gsDocumentBaseTemplate";

Property level As %Integer [ InitialExpression = 1 ];

Property stage As %Integer [ InitialExpression = 1 ];

Property developerMode As %Boolean [ InitialExpression = 0 ];

Property serverIP As %String;

Property serverPort As %Integer;

ClassMethod GetServerIP()
{
	return ##class(%SYSTEM.INetInfo).AddrToHostName(##class(%SYSTEM.INetInfo).TextAddrToBinary("127.0.0.1"))
}

ClassMethod GetServerPort()
{
	return ^%SYS("WebServer","Port")
}

XData Style
{
<style type="text/css">
#zMojoContentBackground{
	height: 5px !important;
	width: 5px !important;
}
.dvEnclosingClass {
	border:none;
}
.dvEnclosingClass iframe {
    position: relative;
    border: none;
}
.progress {
	margin-top: 10px;
	margin-bottom: 0px;
}
.headerDiv .header {
	display: inline-block;
	text-align: center;
	width: 85%;
	position: absolute;
	left: 7.5%;
}

.mainDiv {
	width:95%;
	padding-left:2.5%;
	padding-top:50px;
	/*left:10%;*/
	/*position:absolute;*/
	overflow: hidden;
}
.messageDiv {
	overflow-y: auto;
}
.headerDiv {
	width: 100%;
	height: 50px;
	background-color: black;
	color: white;
	/*text-align: center;*/
	padding: 3px 10px;
	font-size: 2.0em;
}
.headerDiv .ui-btn {
	margin: 0px;
}
.message 
{
	position: relative;
	width: 95%;
	/*height: 120px;*/
	padding: 10px;
	margin:10px;
	background: #EAE9EB;
	border: 1px solid #CCCCCC;
	-webkit-border-radius: 10px;
	-moz-border-radius: 10px;
	border-radius: 10px;
	font-size:larger;
}

.message:after 
{
	content: '';
	position: absolute;
	border-style: solid;
	border-width: 4px 22px 4px 0;
	border-color: transparent #EAE9EB;
	display: block;
	width: 0;
	z-index: 1;
	margin-top: -4px;
	left: -18px;
	top: 50%;
}
.new {
	-webkit-opacity: 0.0;
	-moz-opacity: 0.0;
	opacity: 0.0;
	-webkit-transition: all 2s ease;
	-moz-transition: all 2s ease;
	-ms-transition: all 2s ease;
	-o-transition: all 2s ease;
	transition: all 2s ease;
}
.old {
	-webkit-opacity: 1;
	-moz-opacity: 1;
	opacity: 1;
	
	-webkit-transition: all 2s ease;
	-moz-transition: all 2s ease;
	-ms-transition: all 2s ease;
	-o-transition: all 2s ease;
	transition: all 2s ease;
}
.hidden {
	-webkit-opacity: 0.0;
	-moz-opacity: 0.0;
	opacity: 0.0;
	-webkit-transition: opacitiy 2s ease;
	-moz-transition: opacitiy 2s ease;
	-ms-transition: opacitiy 2s ease;
	-o-transition: opacitiy 2s ease;
	transition: opacitiy 2s ease;
}
.shown {
	-webkit-opacity: 1;
	-moz-opacity: 1;
	opacity: 1;
	
	-webkit-transition: opacitiy 2s ease;
	-moz-transition: opacitiy 2s ease;
	-ms-transition: opacitiy 2s ease;
	-o-transition: opacitiy 2s ease;
	transition: opacitiy 2s ease;
}
pre {
    white-space: pre-wrap;       /* CSS 3 */
    white-space: -moz-pre-wrap;  /* Mozilla, since 1999 */
    white-space: -pre-wrap;      /* Opera 4-6 */
    white-space: -o-pre-wrap;    /* Opera 7 */
    word-wrap: break-word;       /* Internet Explorer 5.5+ */
}
</style>
}

XData pageContents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane
 xmlns="http://www.intersystems.com/zen"
 xmlns:mojo="http://www.intersystems.com/zen/mojo"
 layout="none"
>
 <mojo:documentView
 id="mainView"
ongetdata="return zenPage.getContent('data',key,criteria);"
ongetlayout="return zenPage.getContent('layout',key,criteria);"
initialDocumentKey="stage1"
initialLayoutKey="stage1"
maxPanels="1"
onresolvemethod="return zenPage.onResolveMethod(which, context);"
>
<mojo:mojoDefaultPageManager>
<mojo:bootstrap-3.3.x-Helper/>
<mojo:HTML5Helper/>
<mojo:mojoDefaultHelper/>
</mojo:mojoDefaultPageManager>
</mojo:documentView>
</pane>
}

/// Adjust size of components within the content area.
ClientMethod adjustContentSize(load, width, height) [ Language = javascript ]
{
	var view = zen('mainView');
	if (view) {
		view.setSize(width,height);
		var ws = view.getItemByKey('workspace');
		if (ws) {
			var div = ws.$findElement();
			div.width = (width/2)-85;
			div.height = height - 150;
		}
		var main = view.getItemByKey('mainDiv');
		if (main) {
			var div = main.$findElement();
			//div.style= "height:"+(height - 125)+"px;";
		}
		var tasks = view.getItemByKey('messageDiv');
		if (tasks) {
			var div = tasks.$findElement();
			div.style= "height:"+(height - 150)+"px;";
		}
	}
	zenPage._width = width;
	zenPage._height = height;
	
	if (zenPage._ws === null || typeof(zenPage._ws) === "undefined") {
		zenPage.getTemplate().startWebSocket();
	}
}

ClientMethod onResolveMethod(which, context) [ Language = javascript ]
{
    // dispatch to template object
    var template = this.getTemplate();
    return (template&&template.resolveMethod) ? template.resolveMethod(which, context) : null;
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
Method %OnAfterCreatePage() As %Status
{
	do ##super()
	
	set ..serverIP = ..GetServerIP()
	set ..serverPort = ..GetServerPort()
	
	quit $$$OK
}

}
