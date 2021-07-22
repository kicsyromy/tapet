/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

using GLib;

internal class BingImageProvider : ImageProvider, Object {
    public const int MAX_IMAGE_COUNT = 8;

    public string name () {
        return "Bing";
    }

    public int get_max_image_count () {
        return MAX_IMAGE_COUNT;
    }

    public async ImageMetadata[] get_image_metadata_async (int count) throws Error {
        if (count > MAX_IMAGE_COUNT) {
            count = MAX_IMAGE_COUNT;
        }

        var bing_url = "http://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=" + count.to_string () + "&mkt=en-US";
        var output_stream = new MemoryOutputStream (null);

        var content_type = yield Utilities.download_async (bing_url, output_stream);
        yield output_stream.close_async ();
        if (content_type != "application/json") {
            throw new Error (TapetError.quark, TapetError.Code.SERVER_BAD_RESPONSE, Strings.ERROR_MESSAGE_CONTENT_TYPE_MISSMATCH, content_type);
        }

        var data = output_stream.steal_data ();

        var parser = new Json.Parser ();
        parser.load_from_data ((string)data, (ssize_t)data.length);

        var result = new ImageMetadata[count];

        var root_object = parser.get_root ().get_object ();
        int it = -1;
        foreach (var img in root_object.get_array_member ("images").get_elements ()) {
            ++it;
            var image = img.get_object ();
            var base_url = image.get_string_member ("url");
            var title = image.get_string_member ("title");
            var copyright = image.get_string_member ("copyright");
            var url_parts = base_url.split ("&")[0].split ("_");

            if (url_parts.length != 3) {
                throw new Error (TapetError.quark, TapetError.Code.IMAGE_PROVIDER_BING_BAD_IMAGE_URL, Strings.ERROR_MESSAGE_INVALID_URL, base_url);
            }

            string extension = "." + url_parts[2].split (".")[1];
            var id = url_parts[0] + "_" + url_parts[1] + "_<resolution>" + extension;
            result[it] = new ImageMetadata (id, title, copyright, "", get_mime_type (id), get_extension (id));
        }

        return result;
    }

    public async string save_to_file_async (ImageMetadata image_metadata, ImageQuality quality, string path, string prefix, bool overwrite) throws Error {
        var url = get_url (image_metadata.id, quality);
        var file_name = url.split ("?id=")[1];
        file_name = path + "/" + prefix + file_name;

        var file = File.new_for_path (file_name);
        FileOutputStream output_stream = null;
        try {
            output_stream = yield file.create_async (GLib.FileCreateFlags.NONE);
        } catch (IOError error) {
            if (error.code == IOError.EXISTS) {
                if (!overwrite) {
                    return file_name;
                }

                yield file.delete_async ();

                output_stream = yield file.create_async (GLib.FileCreateFlags.NONE);
            } else {
                throw error;
            }
        }

        yield Utilities.download_async (url, output_stream);
        yield output_stream.close_async ();

        return file_name;
    }

    public async InputStream get_input_stream_async (ImageMetadata image_metadata, ImageQuality quality) throws Error {
        var url = get_url (image_metadata.id, quality);
        return yield Utilities.get_stream_async (url);
    }

    public async void save_to_stream_async (ImageMetadata image_metadata, ImageQuality quality, OutputStream output_stream) throws Error {
        var url = get_url (image_metadata.id, quality);
        yield Utilities.download_async (url, output_stream);
    }

    private static string ? get_mime_type (string id) throws Error {
        for (int i = 0; i < ImageProvider.SUPPORTED_IMAGE_EXTENSIONS.length; ++i) {
            if (id.has_suffix (ImageProvider.SUPPORTED_IMAGE_EXTENSIONS[i])) {
                return ImageProvider.SUPPORTED_IMAGE_TYPES[i];
            }
        }

        return null;
    }

    private static string get_extension (string id) throws Error {
        var split = id.split (".");
        return "." + split[split.length - 1];
    }

    private static string get_url (string id, ImageQuality quality) throws Error {
        string quality_string = "";
        switch (quality) {
        case ImageQuality.NATIVE :
        case ImageQuality.HIGH :
            quality_string = "UHD";
            break;
        case ImageQuality.MEDIUM :
            quality_string = "1920x1080";
            break;
        case ImageQuality.LOW :
            quality_string = "1280x720";
            break;
        }

        return "https://www.bing.com" + id.replace ("<resolution>", quality_string);
    }
}