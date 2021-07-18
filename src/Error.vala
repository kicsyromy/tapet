/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

using GLib ;

internal class TapetError {
    public class Code {
        public const int SERVER_BAD_RESPONSE = 100 ;
        public const int IMAGE_PROVIDER_BING_BAD_IMAGE_URL = 101 ;
    }

    public static Quark quark ;
}