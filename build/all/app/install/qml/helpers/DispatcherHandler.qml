import QtQuick 2.4
import Ubuntu.Components 1.3

Item {
    id:__dispatcherHandler
     function handleURLs(urls) {
        if (urls && urls.length > 0) {
            for(var match in urlMapping) {
                for (var i = 0; i < urls.length; i++) {
                    if (urls[i].match(new RegExp(match))) {
                        console.log("forwarding URL : "+urls[i]);
                        urlMapping[match](urls[i]);
                    }
                }
            }
        }
    }
    
    function handleOnCompleted(args) {
                 var arguments =  (Qt.application.arguments && Qt.application.arguments.length > 0) ?
                            Qt.application.arguments :
                            (args.values.url ? [args.values.url] : []);
        __dispatcherHandler.handleURLs(arguments);
    }

    Connections {
        target: UriHandler

        onOpened: {
            console.log('Opened from UriHandler')

            if (uris.length > 0) {
                handleURLs(uris);
            }
        }
    }
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
