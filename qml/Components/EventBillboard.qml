import QtQuick 2.9

QtObject {
	signal nextStory(bool showDesc);
	signal bookmarkFeed(var feed);
	signal readFeed(var feed);
	signal previousStory(bool showDesc);
	signal addFeed(var feedUrl);
	signal removeFeed(var feedUrl);
	
	
	function triggerNextStory(showDesc) {
		console.log("triggerNextStory signaled")
		nextStory(showDesc);
	}
	function triggerBookmarkFeed(feed)  {
		console.log("triggerBookmarkFeed signaled")
		bookmarkFeed(feed);
	}
	function triggerReadFeed(feed) {
		console.log("triggerReadFeed signaled")
		readFeed(feed);
	}
	function triggerPreviousStory(showDesc) {
		console.log("triggerPreviousStory signaled")
		previousStory(showDesc);
	}
	function triggerRemoveFeed(feedUrl) {
		console.log("triggerRemoveFeed signaled")
		removeFeed(feedUrl);
	}
}
