/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Romeo Calotă <mail@romeocalota.me>
 */

internal class Strings {
    /* Application */
    public const string APPLICATION_ID = "com.github.kicsyromy.tapet";
    public const string APPLICATION_NAME = _ ("Tapet");
    public const string APPLICATION_ERROR_QUARK = APPLICATION_ID;

    public const string APPLICATION_ERROR_INIT_FAILED = _ ("Tapet failed to initialize properly");
    public const string APPLICATION_ERROR_CACHE_CREATE = _ ("Failed to create cache directory");
    public const string APPLICATION_ERROR_CONFIG_CREATE = _ ("Failed to create config directory");
    public const string APPLICATION_ERROR_CONFIG_BACKGROUND_CREATE = _ ("Failed to create background history file. Tapet will not keep track of what wallpapers were applied.");
    public const string APPLICATION_ERROR_CONFIG_BACKGROUND_OPEN = _ ("Failed to open background history file. Tapet will not keep track of what wallpapers were applied.");

    /* Application Settings */
    public const string APPLICATION_SETTINGS_BACKGROUND_CHANGE_INTERVAL = "background-change-interval";
    public const string APPLICATION_SETTINGS_STARTUP_SET_LATEST = "startup-set-latest";
    public const string APPLICATION_SETTINGS_DONT_REUSE_OLD_WALLPAPERS = "dont-reuse-old-wallpapers";
    public const string APPLICATION_SETTINGS_REFRESH_INTERVAL = "refresh-interval";
    public const string APPLICATION_SETTINGS_ENABLE_NOTIFICATIONS = "enable-notifications";
    public const string APPLICATION_SETTINGS_KEEP_RUNNING_WHEN_CLOSED  = "keep-running-when-closed";

    public const string APPLICATION_SETTINGS_CHOICE_NEVER = "0|never";
    public const string APPLICATION_SETTINGS_CHOICE_1_MINUTE = "1|every-min";
    public const string APPLICATION_SETTINGS_CHOICE_5_MINUTES  = "2|every-5-mins";
    public const string APPLICATION_SETTINGS_CHOICE_10_MINUTES = "3|every-10-mins";
    public const string APPLICATION_SETTINGS_CHOICE_15_MINUTES = "4|every-15-mins";
    public const string APPLICATION_SETTINGS_CHOICE_30_MINUTES = "5|every-30-mins";
    public const string APPLICATION_SETTINGS_CHOICE_1_HOUR = "6|every-hour";
    public const string APPLICATION_SETTINGS_CHOICE_2_HOURS = "7|every-2-hours";
    public const string APPLICATION_SETTINGS_CHOICE_4_HOURS = "8|every-4-hours";
    public const string APPLICATION_SETTINGS_CHOICE_6_HOURS = "9|every-6-hours";
    public const string APPLICATION_SETTINGS_CHOICE_12_HOURS = "10|every-12-hours";
    public const string APPLICATION_SETTINGS_CHOICE_1_DAY = "11|every-day";
    public const string[] APPLICATION_SETTINGS_INTERVAL_CHOICES_ALL = {
        APPLICATION_SETTINGS_CHOICE_NEVER,
        APPLICATION_SETTINGS_CHOICE_1_MINUTE,
        APPLICATION_SETTINGS_CHOICE_5_MINUTES,
        APPLICATION_SETTINGS_CHOICE_10_MINUTES,
        APPLICATION_SETTINGS_CHOICE_15_MINUTES,
        APPLICATION_SETTINGS_CHOICE_30_MINUTES,
        APPLICATION_SETTINGS_CHOICE_1_HOUR,
        APPLICATION_SETTINGS_CHOICE_2_HOURS,
        APPLICATION_SETTINGS_CHOICE_4_HOURS,
        APPLICATION_SETTINGS_CHOICE_6_HOURS,
        APPLICATION_SETTINGS_CHOICE_12_HOURS,
        APPLICATION_SETTINGS_CHOICE_1_DAY
    };

    /* Header Bar */
    public const string HEADER_BAR_MENU_TOOLTIP = _ ("Menu");
    public const string HEADER_BAR_BROWSE_BUTTON_LABEL = _ ("_Browse...");
    public const string HEADER_BAR_BROWSE_BUTTON_TOOLTIP = _ ("Browse all previously applied wallpapers");

    public const string HEADER_BAR_DIALOG_WARN_OPEN_CACHE_DIR_FAIL = _ ("Failed to open wallpaper cache directory");

    /* Menu Items */
    public const string MENU_ITEM_SETTINGS = _ ("Settings...");
    public const string MENU_ITEM_ABOUT = _ ("About Tapet");

    /* Settings Dialog */
    public const string SETTINGS_LABEL_SECTION_GENERAL_SETTINGS = _ ("General settings");
    public const string SETTINGS_LABEL_ITEM_BACKGROUND_CHANGE_INTERVAL = _ ("Change the wallpaper automatically");
    public const string SETTINGS_LABEL_ITEM_DONT_REUSE_OLD_WALLPAPERS = _ ("When changing wallpaper automatically, don't set any previously set wallpapers");
    public const string SETTINGS_LABEL_ITEM_STARTUP_SET_LATEST = _ ("When starting set the most recent image available as wallpaper");
    public const string SETTINGS_LABEL_ITEM_REFRESH_INTERVAL = _ ("Refresh the list of available wallpapers");
    public const string SETTINGS_LABEL_ITEM_ENABLE_NOTIFICATIONS = _ ("Display a notification when changing wallpaper");

    public const string SETTINGS_COMBO_BOX_INTERVAL_NEVER = _ ("Never");
    public const string SETTINGS_COMBO_BOX_INTERVAL_1_MINUTE = _ ("Every minute");
    public const string SETTINGS_COMBO_BOX_INTERVAL_5_MINUTES = _ ("Every 5 minutes");
    public const string SETTINGS_COMBO_BOX_INTERVAL_10_MINUTES = _ ("Every 10 minutes");
    public const string SETTINGS_COMBO_BOX_INTERVAL_15_MINUTES = _ ("Every 15 minutes");
    public const string SETTINGS_COMBO_BOX_INTERVAL_30_MINUTES = _ ("Every 30 minutes");
    public const string SETTINGS_COMBO_BOX_INTERVAL_1_HOUR = _ ("Every hour");
    public const string SETTINGS_COMBO_BOX_INTERVAL_2_HOURS = _ ("Every 2 hours");
    public const string SETTINGS_COMBO_BOX_INTERVAL_4_HOURS = _ ("Every 4 hours");
    public const string SETTINGS_COMBO_BOX_INTERVAL_6_HOURS = _ ("Every 6 hours");
    public const string SETTINGS_COMBO_BOX_INTERVAL_12_HOURS = _ ("Every 12 hours");
    public const string SETTINGS_COMBO_BOX_INTERVAL_1_DAY = _ ("Every day");

    public const string SETTINGS_LABEL_SECTION_APPLICATION_SETTINGS = _ ("Application settings");
    public const string SETTINGS_LABEL_ITEM_KEEP_RUNNING_WHEN_CLOSED = _ ("Keep Tapet running in the background when closed");

    /* Main Content */
    public const string CONTENT_POPOVER_SET_BACKGROUND = _ ("Set as wallpaper");
    public const string CONTENT_POPOVER_SAVE_AS = _ ("Save as...");

    public const string CONTENT_WARN_SET_BACKGROUND_FAIL_PRIMARY = _ ("Failed to set wallpaper");
    public const string CONTENT_WARN_SAVE_BACKGROUND_FAIL_PRIMARY = _ ("Failed to save wallpaper");

    public const string CONTENT_DIALOG_KEEP_RUNNING_PRIMARY = _ ("Keep application running in the background?");
    public const string CONTENT_DIALOG_KEEP_RUNNING_DESCRIPTION = _ ("In order to refresh the list of available wallpapers and update the current wallpaper automatically, Tapet can run in the background.\n\nDo you want to allow Tapet to keep running after this window has been closed?");

    public const string DEBUG_APPLY_WALLPAPER = _ ("Applying wallpaper");

    public const string WARN_DOWNLOAD_IMAGE = _ ("Failed to download image from provider");
    public const string WARN_DOWNLOAD_IMAGES = _ ("Failed to download images from provider");

    /* Miscellaneous */
    public const string MISC_OPEN = _ ("_Open");
    public const string MISC_SAVE = _ ("_Save");
    public const string MISC_CLOSE = _ ("_Close");
    public const string MISC_CANCEL = _ ("_Cancel");
    public const string MISC_QUIT = _ ("_Quit");
    public const string MISC_YES = _ ("_Yes");
    public const string MISC_NO = _ ("_No");

    public const string MISC_IMAGE_FILTER_NAME = _ ("Image");

    public const string MISC_BACKGROUND_SCHEMA = "org.gnome.desktop.background";
    public const string MISC_BACKGROUND_PICTURE_URI_KEY = "/org/gnome/desktop/background/picture-uri";
    public const string MISC_BACKGROUND_PICTURE_OPTIONS = "/org/gnome/desktop/background/picture-options";

    public const string ERROR_MESSAGE_BAD_RESPONSE = _ ("Download failed, server responded with");
    public const string ERROR_MESSAGE_CONTENT_TYPE_MISSMATCH = _ ("Server responded with an invalid content type; expected 'application/json' got '%s'");
    public const string ERROR_MESSAGE_INVALID_URL = _ ("Invalid image url in response: %s");

    public const string NOTIFICATION_BACKGROUND_SET_TITLE = _ ("Wallpaper Changed");
    public const string NOTIFICATION_BACKGROUND_SET_MESSAGE = _ ("'%s' set as wallpaper. Enjoy!");
}
