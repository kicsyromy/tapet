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

internal interface ImageProvider : Object {
    public const string[] SUPPORTED_IMAGE_TYPES = { "image/jpeg", "image/png", "image/bmp" } ;
    public const string[] SUPPORTED_IMAGE_EXTENSIONS = { ".jpg", ".png", ".bmp" } ;

    public abstract string name() ;
    public abstract int get_max_image_count() ;

    public abstract async string[] get_image_ids_async(int count) throws Error ;
    public abstract async string get_image_url_async(string id, ImageQuality quality = ImageQuality.NATIVE) throws Error ;
    public abstract async string save_async(string url, string path, string prefix, bool overwrite = true) throws Error ;

}
