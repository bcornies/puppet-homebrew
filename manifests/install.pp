class homebrew::install {
  $directories = [ '/usr/local',
                   '/usr/local/bin',
                   '/usr/local/etc',
                   '/usr/local/include',
                   '/usr/local/lib',
                   '/usr/local/lib/pkgconfig',
                   '/usr/local/Library',
                   '/usr/local/sbin',
                   '/usr/local/share',
                   '/usr/local/var',
                   '/usr/local/var/log',
                   '/usr/local/share/locale',
                   '/usr/local/share/man',
                   '/usr/local/share/man/man1',
                   '/usr/local/share/man/man2',
                   '/usr/local/share/man/man3',
                   '/usr/local/share/man/man4',
                   '/usr/local/share/man/man5',
                   '/usr/local/share/man/man6',
                   '/usr/local/share/man/man7',
                   '/usr/local/share/man/man8',
                   '/usr/local/share/info',
                   '/usr/local/share/doc',
                   '/usr/local/share/aclocal' ]

  $repository = [ '/usr/local/Library',
                  '/usr/local/bin',
                  '/usr/local/share',
                  '/usr/local/README.md',
                  '/usr/local/.git',
                  '/usr/local/.gitignore' ]

  file { $directories:
    ensure => directory,
    owner  => $homebrew::user,
    group  => 'admin',
    mode   => 0775,
  }

  exec { 'install-homebrew':
    cwd       => '/usr/local',
    command   => "/usr/bin/su ${homebrew::user} -c '/bin/bash -o pipefail -c \"/usr/bin/curl -skSfL https://github.com/mxcl/homebrew/tarball/master | /usr/bin/tar xz -m --strip 1\"'",
    creates   => '/usr/local/bin/brew',
    logoutput => on_failure,
    timeout   => 0,
    require   => File[$directories],
  }

  file { $repository:
    owner     => $homebrew::user,
    group     => 'admin',
    mode      => 0775,
    recurse   => true,
    subscribe => Exec['install-homebrew'],
  }
}
