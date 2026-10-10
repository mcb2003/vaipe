project('vaipe', 'vala', 'c',
  version: '0.1.0',
  license: 'GPL-3.0-only',
)

executable('vaipe',
  'src/main.vala',
  'src/application.vala',
  'src/window.vala',
  'src/command_entry.vala',
  c_args: ['-w'],
  dependencies: [
    dependency('gtk4'),
    dependency('gtksourceview-5'),
  ],
  install: true,
)

install_data('data/vip.thefake.vaipe.desktop',
  install_dir: get_option('datadir') / 'applications',
)
