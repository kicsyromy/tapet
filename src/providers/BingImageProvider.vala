/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

using GLib ;

internal class BingImageProvider : ImageProvider, Object {
    public const int MAX_IMAGE_COUNT = 8 ;

    public string name() {
        return "Bing" ;
    }

    public int get_max_image_count() {
        return MAX_IMAGE_COUNT ;
    }

    public async string[] get_image_ids(int count) throws Error {
        if( count > MAX_IMAGE_COUNT ){
            count = MAX_IMAGE_COUNT ;
        }

        var bing_url = "http://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=" + count.to_string () + "&mkt=en-US" ;
        var output_stream = new MemoryOutputStream (null) ;

        string content_type = null ;

        try {
            content_type = yield Utilities.download_async(bing_url, output_stream) ;

            output_stream.close () ;
        } catch ( Error error ) {
            throw error ;
        }

        if( content_type != "application/json" ){
            throw new Error (TapetError.quark, TapetError.Code.SERVER_BAD_RESPONSE, "Server responded with an invalid content type; expected 'application/json' got '%s'", content_type) ;
        }

        var data = output_stream.steal_data () ;

        var parser = new Json.Parser () ;
        try {
            parser.load_from_data ((string) data, (ssize_t) data.length) ;
        } catch ( Error error ) {
            throw error ;
        }

        var result = new string[count] ;

        var root_object = parser.get_root ().get_object () ;
        int it = -1 ;
        foreach( var img in root_object.get_array_member ("images").get_elements ()){
            ++it ;
            var image = img.get_object () ;
            var base_url = image.get_string_member ("url") ;
            var url_parts = base_url.split ("&")[0].split ("_") ;

            if( url_parts.length != 3 ){
                throw new Error (TapetError.quark, TapetError.Code.IMAGE_PROVIDER_BING_BAD_IMAGE_URL, "Invalid image url in response: %s", base_url) ;
            }

            string extension = "." + url_parts[2].split (".")[1] ;
            var id = url_parts[0] + "_" + url_parts[1] + "_<resolution>" + extension ;
            result[it] = id ;
        }

        return result ;
    }

    public async string get_image_url(string id, ImageQuality quality) throws Error {
        string quality_string = "" ;
        switch( quality ){
        case ImageQuality.NATIVE:
        case ImageQuality.HIGH:
            quality_string = "UHD" ;
            break ;
        case ImageQuality.MEDIUM:
            quality_string = "1920x1080" ;
            break ;
        case ImageQuality.LOW:
            quality_string = "1280x720" ;
            break ;
        }

        return "https://www.bing.com" + id.replace ("<resolution>", quality_string) ;
    }

    public async string save(string url, string path, string prefix) throws Error {
        var file_name = url.split ("?id=")[1] ;
        file_name = path + "/" + prefix + file_name ;

        var file = File.new_for_path (file_name) ;
        FileOutputStream output_stream = null ;
        try {
            output_stream = yield file.create_async(GLib.FileCreateFlags.NONE) ;

        } catch ( IOError error ) {
            if( error.code == IOError.EXISTS ){
                yield file.delete_async() ;

                try {
                    output_stream = yield file.create_async(GLib.FileCreateFlags.NONE) ;

                } catch ( Error errro ) {
                    throw error ;
                }
            }
        }

        string content_type = null ;
        try {
            content_type = yield Utilities.download_async(url, output_stream) ;

            output_stream.close () ;
        } catch ( Error error ) {
            throw error ;
        }

        return file_name ;
    }

}