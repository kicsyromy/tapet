/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

using GLib ;

internal class Utilities {
    public static async string download_async(string url, OutputStream output_stream) throws Error {
        string content_type = null ;
        var in_stream = yield get_stream_async(url, out content_type) ;

        yield output_stream.splice_async(in_stream, OutputStreamSpliceFlags.CLOSE_SOURCE) ;

        return content_type ;
    }

    public static async InputStream get_stream_async(string url, out string content_type = null) throws Error {
        var session = new Soup.Session () ;
        var msg = new Soup.Message ("GET", url) ;

        var in_stream = yield session.send_async(msg, null) ;

        if( msg.status_code != 200 ){
            throw new Error (TapetError.quark, TapetError.Code.SERVER_BAD_RESPONSE, "%s: %u %s", Strings.ERROR_MESSAGE_BAD_RESPONSE, msg.status_code, msg.reason_phrase) ;
        }

        content_type = msg.response_headers.get_content_type (null) ;
        return in_stream ;
    }

}