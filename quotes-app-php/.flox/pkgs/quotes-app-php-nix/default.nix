{ php, runCommand }:
runCommand "quotes-app"
  {
    version = "0.0.1";
  }
  ''
    mkdir -p $out/{lib/quotes-app-php-nix,bin}
    cp -p  ${./../../../index.php} $out/lib/quotes-app-php-nix/index.php
    cp -p  ${./../../../quotes.json} $out/lib/quotes-app-php-nix/quotes.json


    echo "#!/usr/bin/env sh" > $out/bin/quotes-app-php-nix
    echo "cd $out/lib/quotes-app-php-nix && exec ${php}/bin/php -S localhost:3000" >> $out/bin/quotes-app-php-nix
    chmod 755 $out/bin/*
  ''
