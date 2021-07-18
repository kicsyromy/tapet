/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

using GLib ;

internal class Utilities {
    public static async void download_async(string url, OutputStream output_stream) throws Error {
        var session = new Soup.Session () ;
        var msg = new Soup.Message ("GET", url) ;

        InputStream in_stream = null ;
        try {
            in_stream = yield session.send_async(msg, null) ;

        } catch ( Error error ) {
            printerr ("Failed to send HTTP request: %d: %s\n", error.code, error.message) ;
            throw error ;
        }

        if( msg.status_code != 200 ){
            printerr ("Failed to download file from %s: %u: %s\n", url, msg.status_code, msg.reason_phrase) ;
            throw new Error (Quark.from_string (Strings.APPLICATION_ID), 10001, "Network failure") ;
        }

        try {
            yield output_stream.splice_async(in_stream, OutputStreamSpliceFlags.CLOSE_SOURCE) ;

        } catch ( IOError error ) {
            printerr ("Failed to download from HTTP stream: %d: %s\n", error.code, error.message) ;
            throw error ;
        }
    }

}