import QtQuick.XmlListModel 2.0

XmlListModel {
	id:_rssChannel
	
    source: "https://omgubuntu.co.uk/feed"
    query: "/(rss/channel|feed)"
	XmlRole { name: "titleText"; query: "title/string()" }
	XmlRole { name: "description"; query: "description/string()" }
	XmlRole { name: "imageUrl"; query: "image/url/string()" }
	XmlRole { name: "pubDate"; query: "(pubDate|updated)/string()" }
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


