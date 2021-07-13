# project name and programming language
project('com.github.kicsyromy.tapet', 'vala', 'c')

# Include the translations module
i18n = import('i18n')

# Set our translation domain
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

# Create a new executable, list the files we want to compile, list the dependencies we need, and install
executable(
    meson.project_name(),
    'src' / 'Application.vala',
    'src' / 'HeaderBar.vala',
    'src' / 'MainWindow.vala',
    'src' / 'native.c',
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('libhandy-1')
    ],
    install: true
)

#Translate and install our .desktop file
i18n.merge_file(
    input: 'data' / 'tapet.desktop.in',
    output: meson.project_name() + '.desktop',
    po_dir: meson.source_root() / 'po',
    type: 'desktop',
    install: true,
    install_dir: get_option('datadir') / 'applications'
)

#Translate and install our .appdata file
i18n.merge_file(
    input: 'data' / 'tapet.appdata.xml.in',
    output: meson.project_name() + '.appdata.xml',
    po_dir: meson.source_root() / 'po',
    install: true,
    install_dir: get_option('datadir') / 'metainfo'
)

# Install our icons in all the required sizes
icon_sizes = ['16', '32', '48', '64', '128']
foreach i : icon_sizes
    # LoDPI icons
    install_data(
        'data' / 'icons' / i + '.svg',
        install_dir: get_option('datadir') / 'icons' / 'hicolor' / i + 'x' + i / 'apps',
        rename: meson.project_name() + '.svg'
    )
    # HiDPI icons
    install_data(
        'data' / 'icons' / i + '.svg',
        install_dir: get_option('datadir') / 'icons' / 'hicolor' / i + 'x' + i + '@2' / 'apps',
        rename: meson.project_name() + '.svg'
    )
endforeach

# Install symbolic version of the icon
# LoDPI
install_data(
    'data' / 'icons' / 'symbolic.svg',
    install_dir: get_option('datadir') / 'icons' / 'hicolor' / 'symbolic' / 'apps',
    rename: meson.project_name() + '.svg'
)

# HiDPI
install_data(
    'data' / 'icons' / 'symbolic.svg',
    install_dir: get_option('datadir') / 'icons' / 'hicolor' / 'symbolic@2' / 'apps',
    rename: meson.project_name() + '.svg'
)

# Install scalable version of the icon
# LoDPI
install_data(
    'data' / 'icons' / 'scalable.svg',
    install_dir: get_option('datadir') / 'icons' / 'hicolor' / 'scalable' / 'apps',
    rename: meson.project_name() + '.svg'
)

# HiDPI
install_data(
    'data' / 'icons' / 'scalable.svg',
    install_dir: get_option('datadir') / 'icons' / 'hicolor' / 'scalable@2' / 'apps',
    rename: meson.project_name() + '.svg'
)

subdir('po')
