Class Document.UI.Application Extends %ZEN.Mojo.baseApplication
{

/// This is the name of this application.
Parameter APPLICATIONNAME = "Global Summit - Document Data Model Experience";

/// This is the URL of the main starting page of this application.
Parameter HOMEPAGE = "Document.UI.Start.cls";

/// This Style block contains application-wide CSS style definitions.
XData Style
{
<style type="text/css">
	</style>
}

/// Return an object containing the various configured settings for the portal.
ClassMethod %GetAppSettings(pPage As %String = "", pMode As %String = "") As %ZEN.proxyObject
{
	
	Set tInfo = ##class(%ZEN.proxyObject).%New()
	// names
	Set tInfo.nameApplication = "Global Summit - Document Data Model Experience"

	Quit tInfo
}

}
