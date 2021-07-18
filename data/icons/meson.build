# Install our icons in all the required sizes
icon_sizes = ['16', '32', '48', '64', '128']
foreach i : icon_sizes
    # LoDPI icons
    install_data(
        i + '.svg',
        install_dir: get_option('datadir') / 'icons' / 'hicolor' / i + 'x' + i / 'apps',
        rename: meson.project_name() + '.svg'
    )
    # HiDPI icons
    install_data(
        i + '.svg',
        install_dir: get_option('datadir') / 'icons' / 'hicolor' / i + 'x' + i + '@2' / 'apps',
        rename: meson.project_name() + '.svg'
    )
endforeach

# Install symbolic version of the icon
# LoDPI
install_data(
    'symbolic.svg',
    install_dir: get_option('datadir') / 'icons' / 'hicolor' / 'symbolic' / 'apps',
    rename: meson.project_name() + '.svg'
)

# HiDPI
install_data(
    'symbolic.svg',
    install_dir: get_option('datadir') / 'icons' / 'hicolor' / 'symbolic@2' / 'apps',
    rename: meson.project_name() + '.svg'
)

# Install scalable version of the icon
# LoDPI
install_data(
    'scalable.svg',
    install_dir: get_option('datadir') / 'icons' / 'hicolor' / 'scalable' / 'apps',
    rename: meson.project_name() + '.svg'
)

# HiDPI
install_data(
    'scalable.svg',
    install_dir: get_option('datadir') / 'icons' / 'hicolor' / 'scalable@2' / 'apps',
    rename: meson.project_name() + '.svg'
)