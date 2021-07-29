var mapping = {
	"feed_path" : "/index.php/apps/news/api/v1-2/feeds",
	"bkmrk_feed_path" : "/index.php/apps/news/api/v1-2/items/__ID__/__GUID__/star",
	"unbkmrk_feed_path" : "/index.php/apps/news/api/v1-2/items/__ID__/__GUID__/unstar",
	"add_feed_path" : "/index.php/apps/news/api/v1-2/feeds",
	"remove_feed_path" : "/index.php/apps/news/api/v1-2/feeds/__ID__",
	"read_feed_path" : "/index.php/apps/news/api/v1-2/feeds/__ID__/read"
}

var pathArgMapping = {
	"__ID__" : "id",
	"__GUID__" : "guid",
	"__GUIDHASH__" : "guidHash",
}

var lastFeedList = [];
var lastCreds = null;

function getFeeds(nextCloudCreds, callback) {
	
	var xhr = new XMLHttpRequest();
	console.log(nextCloudCreds.host+mapping['feed_path']);
	xhr.open("GET",nextCloudCreds.host+mapping['feed_path']);
	xhr = this.addCredsToXhr(xhr,{host : nextCloudCreds.host, encodedCreds: nextCloudCreds.encodedCreds });
	if(!xhr) {//auth failed
		return false;
	}
	xhr.onreadystatechange = function() {
		console.log(xhr.status,xhr.readyState,xhr.responseText);
		if (xhr.readyState == 4 && xhr.status == 200) {
			var parsedData = JSON.parse(xhr.responseText);
			callback(parsedData);
			lastFeedList = parsedData.feeds;
			if(lastFeedList) {
				lastCreds = {host : nextCloudCreds.host, encodedCreds: nextCloudCreds.encodedCreds}; 
			}
		}
	};
	xhr.send();
	return  true;
}

function addFeed(nextCloudCreds, newFeed, callback, failback) {
	
	var xhr = new XMLHttpRequest();
	xhr.open("POST",nextCloudCreds.host+mapping['add_feed_path']);
	console.log(nextCloudCreds.host+mapping['add_feed_path']);
	xhr = this.addCredsToXhr(xhr,nextCloudCreds);
	if(!xhr) {//auth failed
		return false;
	}
	xhr.onreadystatechange =this.getHttpHandlerFunc(xhr, callback, failback);
	console.log(JSON.stringify({url:newFeed,folderId:null}));
	xhr.send(JSON.stringify({url:newFeed,folderId:null}));
	return  true;
}

function removeFeed(nextCloudCreds, feedToRemove, callback, failback) {
	
	var feedData = getFeedByURL(feedToRemove);
	if(!feedData) {  return false }
	
	var xhr = new XMLHttpRequest();
	console.log(nextCloudCreds.hostpathArgMapping( mapping['remove_feed_path'],feedData));
	xhr.open("DELETE",nextCloudCreds.host+pathArgMapping( mapping['remove_feed_path'],feedData));
	xhr = this.addCredsToXhr(xhr,nextCloudCreds);
	if(!xhr) {//auth failed
		return false;
	}
	xhr.onreadystatechange =this.getHttpHandlerFunc(xhr, callback, failback);
	xhr.send();
	return  true;
}

function bookmarkFeed(nextCloudCreds, feedUrl, callback, failback) {
	
	
	var feedData = getFeedByURL(feedUrl);
	if(!feedData) {  return false }
	
	var xhr = new XMLHttpRequest();
	xhr.open("PUT",nextCloudCreds.host + pathArgMapping( mapping['bkmrk_feed_path'],feedData));
	xhr = this.addCredsToXhr(xhr,nextCloudCreds);
	if(!xhr) {//auth failed
		return false;
	}
	
	xhr.onreadystatechange = this.getHttpHandlerFunc(xhr, callback, failback);
	xhr.send(JSON.stringify({url:feedToBkmrk,folderId:null}));
	return  true;
}

function readFeed(nextCloudCreds, feedUrl, callback, failback) {

	var feedData = getFeedByURL(feedUrl);
	if(!feedData) {  return false }

	var xhr = new XMLHttpRequest();
	xhr.open("PUT",nextCloudCreds.host+pathArgMapping( mapping['read_feed_path'],feedData));
	
	xhr = this.addCredsToXhr(xhr,nextCloudCreds);
	if( !xhr ) {//auth failed
		return false;
	}
	
	xhr.onreadystatechange = this.getHttpHandlerFunc(xhr, callback, failback);
	xhr.send(JSON.stringify({url:newFeed,folderId:null}));
	return  true;
}

//--------------------------------------------------------------------------------------

function isCredentialValid(nextCloudCreds) {
	return nextCloudCreds.host.match(/^https:/) && nextCloudCreds.encodedCreds;
}

//---------------------------------------------------------------------------------------

function relpacePathValues(path, feed) {
	for(var i in pathArgMapping) {
			var regex = new RegEx(i);
			if( path.match(regex) && feed[pathArgMapping[i]] ) {
				path = path.replace(regex,feed[pathArgMapping[i]]);
			}
	}
	return path;
}

function getFeedByURL(feedURL) {
	if(typeof( lastFeedList ) === 'object' ) {
		for(var i in lastFeedList) {
			if(lastFeedList[i].url == feedURL ) {
				return lastFeedList[i];
			}
		}
	}
	return null;
}

function addCredsToXhr(xhr,nextCloudCreds) {
	if(!nextCloudCreds.host.match(/^https:/)) {
		console.log("Host is not under SSL! failing instead of exposing credentials... ");
		return false;
	}
	var creds = nextCloudCreds.encodedCreds;
	xhr.setRequestHeader('Authorization', 'Basic '+creds);
	return xhr;
}

function getHttpHandlerFunc(xhr, callback, failback) {
	return function() {
		console.log(xhr.status,xhr.readyState,xhr.responseText);
		if (xhr.readyState == 4 && xhr.status == 200) {
			if(callback) {
				callback(JSON.parse(xhr.responseText));
			}
		} else if(xhr.readyState == 4 && xhr.status !== 200) {
			if(failback) {
				failback(xhr.responseText);
			}
		}
	};
}
