var mapping = { 
	'item' : {
		title : "title",
		link : "link",
		description: "description",
		date : "pubDate",
		author : "author"
	},
	channel : {
		title : "title",
		image : { key :  "image",
				  data : {
					title : "title",
					url : "url",
					link : "link"
				},
		},
		description : "description",
		language : "language",
		date : "pubDate",
		link : "link"
	},
};

/**
 *  Retrive and parse data from an RSS URL
 * @returns a Promise object with the first element containing the parsed data
 */
function parseFeedData(feedRawData) {
	return (new DOMParser()).parseFromString(feedRawData, "text/xml");
}

/**
 * Get all feed items
 */
function getAllItems(rssData) {
	var retItems = [];
	var items = rssData.querySelectorAll('item');
	for(var i in items) {
		retItems.push(self.elementMapping(items[i],mapping['item']));
	};
	return retItems;
}

/**
 * retrive a single channel metadata
 */
function getChannelData(rssData, chIdx) {
	chIdx = chIdx  ? chIdx : 0;
	var channels = data.querySelectorAll('channel');
	if(undefined === channels[chIdx]) {	
		return {};
	}
	var channel = channels[0];
	return slef.elementMapping(channel, mapping['channel']);
}

function elementMapping(elem,mapping) {
	var newObj = {};
	for( var k in mapping ) {
		if (typeof mapping[k] == 'string') {
			newObj[k] = elem.querySelector(mapping[k]);
		} else {
			newObj[k] = self.elementMapping(elem.querySelector(mapping[k]['key']),mapping[k]['data'])
		}
	}
	return newObj;
}
