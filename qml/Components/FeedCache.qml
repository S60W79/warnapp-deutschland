import QtQuick 2.9
import U1db 1.0 as U1db

Item {
	id:_feedCache
	
	property alias db:cachedReqDbInstance
	
	function getDoc(key) {
		getPreviousResponses.query = [ key ];
		if(getPreviousResponses.results.length) {
			for(var i in getPreviousResponses.documents) {
				var cachedDoc = cachedReqDbInstance.getDoc(getPreviousResponses.documents[i]);
				if(cachedDoc && cachedDoc.value) {
					return cachedDoc.value;
				}
			}
		}
		return null;
	}
	
	function putDoc(key,value) {
		db.putDoc({"source":key, "value": value})
	}
	
	
	U1db.Database {
		id:cachedReqDbInstance
		path: "cached-requests-db"
	}

	U1db.Index {
		id:sourceIndex
		database:cachedReqDbInstance
 		name:"sourceIndex"
		expression: [ "source" ]
	}
	U1db.Query {
		id:getPreviousResponses
		index: sourceIndex
		query: ["*"]
	}
}
 /** Copyright (C) 2021  Eran DarkEye Uzan
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * darkeye.ursses is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */



