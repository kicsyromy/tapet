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
    public abstract int max_image_count() ;

    public abstract async string[] get_image_urls(int count, ImageQuality quality = ImageQuality.NATIVE) throws Error ;
    public abstract async string save(string url, string path, string prefix) throws Error ;

}
