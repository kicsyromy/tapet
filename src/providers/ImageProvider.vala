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
    public abstract async string[] get_image_urls(int count, ImageQuality quality = ImageQuality.NATIVE) throws Error ;

}
