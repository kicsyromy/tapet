/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

using GLib ;

internal class BingImageProvider : ImageProvider, Object {
    public const int MAX_IMAGE_COUNT = 8 ;

    public async string[] get_image_urls(int count, ImageQuality quality = ImageQuality.NATIVE) throws Error {
        if( count > MAX_IMAGE_COUNT ){
            count = MAX_IMAGE_COUNT ;
        }

        var bing_url = "http://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=" + count.to_string () + "&mkt=en-US" ;
        var output_stream = new MemoryOutputStream (null) ;

        try {
            yield Utilities.download_async(bing_url, output_stream) ;

            output_stream.close () ;
        } catch ( Error error ) {
            printerr ("Failed to download image list from %s: %d: %s\n", bing_url, error.code, error.message) ;
            throw error ;
        }

        var data = output_stream.steal_data () ;

        var parser = new Json.Parser () ;
        try {
            parser.load_from_data ((string) data, (ssize_t) data.length) ;
        } catch ( Error error ) {
            printerr ("Failed to parse json: %d: %s\n", error.code, error.message) ;
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
            string quality_string = "" ;
            switch( quality ){
            case ImageQuality.NATIVE:
            case ImageQuality.HIGH:
                quality_string = "_UHD" ;
                break ;
            case ImageQuality.MEDIUM:
                quality_string = "_1920x1080" ;
                break ;
            case ImageQuality.LOW:
                quality_string = "_1280x720" ;
                break ;
            }

            var final_url = "https://www.bing.com" + url_parts[0] + "_" + url_parts[1] + quality_string + extension ;
            result[it] = final_url ;
        }

        // var file_stream = File.new_for_path (Application.cache_dir).create (FileCreateFlags.NONE) ;
        // Utilities.download_async.begin ("http://cdn.onlinewebfonts.com/svg/img_410.png", file_stream, (obj, res) => {
        // Utilities.download_async.end (res) ;
        // }) ;

        return result ;
    }

}