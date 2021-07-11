# project name and programming language
project('com.github.kicsyromy.tapet', 'vala', 'c')

# Create a new executable, list the files we want to compile, list the dependencies we need, and install
executable(
    meson.project_name(),
    'src' / 'Application.vala',
    'src' / 'extern_functions.c',
    dependencies: [
        dependency('gtk+-3.0')
    ],
    install: true
)

# Install our .desktop file so the Applications Menu will see it
install_data(
    'data' / 'tapet.desktop',
    install_dir: get_option('datadir') / 'applications',
    rename: meson.project_name() + '.desktop'
)

# Install our .appdata.xml file so AppCenter will see it
install_data(
    'data' / 'tapet.appdata.xml',
    install_dir: get_option('datadir') / 'metainfo',
    rename: meson.project_name() + '.appdata.xml'
)

# Install our icons in all the required sizes
icon_sizes = ['16', '32', '48', '64', '128']
foreach i : icon_sizes
    # LoDPI icons
    install_data(
        'data' / i + '.svg',
        install_dir: get_option('datadir') / 'icons' / 'hicolor' / i + 'x' + i / 'apps',
        rename: meson.project_name() + '.svg'
    )
    # HiDPI icons
    install_data(
        'data' / i + '.svg',
        install_dir: get_option('datadir') / 'icons' / 'hicolor' / i + 'x' + i + '@2' / 'apps',
        rename: meson.project_name() + '.svg'
    )
endforeach

# Install symbolic version of the icon
# LoDPI
install_data(
    'data' / 'symbolic.svg',
    install_dir: get_option('datadir') / 'icons' / 'hicolor' / 'symbolic' / 'apps',
    rename: meson.project_name() + '.svg'
)

# HiDPI
install_data(
    'data' / 'symbolic.svg',
    install_dir: get_option('datadir') / 'icons' / 'hicolor' / 'symbolic@2' / 'apps',
    rename: meson.project_name() + '.svg'
)

# Install scalable version of the icon
# LoDPI
install_data(
    'data' / 'scalable.svg',
    install_dir: get_option('datadir') / 'icons' / 'hicolor' / 'scalable' / 'apps',
    rename: meson.project_name() + '.svg'
)

# HiDPI
install_data(
    'data' / 'scalable.svg',
    install_dir: get_option('datadir') / 'icons' / 'hicolor' / 'scalable@2' / 'apps',
    rename: meson.project_name() + '.svg'
)
