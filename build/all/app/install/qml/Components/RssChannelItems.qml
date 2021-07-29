import QtQuick.XmlListModel 2.0

XmlListModel {
    source: "https://omgubuntu.co.uk/feed"
    query: "/(rss/channel|feed)/(item|entry)"
 	//namespaceDeclarations: "declare default element namespace 'http://www.w3.org/2005/Atom';"
	XmlRole { name: "titleText"; query: "title/string()" }
	XmlRole { name: "description"; query: "(description|summary)/string()" }
	//XmlRole { name: "category"; query: "category/node()" }
	XmlRole { name: "imageUrl"; query: "image/@href/string()" }
	XmlRole { name: "updated"; query: "(pubDate|updated)/string()" }
	XmlRole { name: "author"; query: "(author|owner|creator|author/name)/string()" }
	XmlRole { name: "url"; query: "(link[contains(text(),'http')]|id[contains(text(),'http')])/string()"; isKey: true }
	XmlRole { name: "content"; query: "(content)/string()" }
	
}
/*
 * Copyright (C) 2021  Eran DarkEye Uzan
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


