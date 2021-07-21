/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

using GLib ;

enum ImageQuality {
    LOW,
    MEDIUM,
    HIGH,
    NATIVE
}

class ImageMetadata {
    public string id { get ; private set ; }

    public string title { get ; private set ; }
    public string copyright { get ; private set ; }
    public string description { get ; private set ; }

    public string mime_type { get ; private set ; }
    public string extension { get ; private set ; }

    public ImageMetadata (string id, string title, string copyright, string description, string mime_type, string extension) {
        this.id = id ;
        this.title = title ;
        this.copyright = copyright ;
        this.description = description ;
        this.mime_type = mime_type ;
        this.extension = extension ;
    }

}

internal interface ImageProvider : Object {
    public const string[] SUPPORTED_IMAGE_TYPES = { "image/jpeg", "image/png", "image/bmp" } ;
    public const string[] SUPPORTED_IMAGE_EXTENSIONS = { ".jpg", ".png", ".bmp" } ;

    public abstract string name() ;
    public abstract int get_max_image_count() ;

    public abstract async ImageMetadata[] get_image_metadata_async(int count) throws Error ;

    public abstract async string save_to_file_async(ImageMetadata image_metadata, ImageQuality quality, string path, string prefix, bool overwrite = true) throws Error ;

    public abstract async InputStream get_input_stream_async(ImageMetadata image_metadata, ImageQuality quality) throws Error ;
    public abstract async void save_to_stream_async(ImageMetadata image_metadata, ImageQuality quality, OutputStream output_stream) throws Error ;

}
