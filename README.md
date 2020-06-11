# GleSYS One-Click Installers [![License: CC0-1.0](https://img.shields.io/badge/License-CC0%201.0-lightgrey.svg)](http://creativecommons.org/publicdomain/zero/1.0/)
> The scripts that powers the one-click installers on GleSYS Cloud (cloud.glesys.com).

## Guidelines

1. The one-click installer should be placed in a folder which is named after a rundown of what it does. Eg. `wordpress-nginx-mariadb`.
2. The folder should include a `cloud-config.yaml`, which should include the cloud-init code. And a `README.md`, which should include a summary of what it does.
3. Include other license information in your `cloud-config.yaml` if the global license isn't applicable for your contribution (see License section below).
4. When your cloud-init is merged, it still has to be integrated in the GleSYS Cloud interface. This doesn't happen automatically.


## Contributing

1. Fork it (<https://github.com/yourname/yourproject/fork>)
2. Create your feature branch (`git checkout -b feature/fooBar`)
3. Commit your changes (`git commit -am 'Add some fooBar'`)
4. Push to the branch (`git push origin feature/fooBar`)
5. Create a new Pull Request

## License

GleSYS one-click installers is open-sourced software licensed under the [CC0 1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/deed.en). Separate one-click installers may use other licenses and if so, they should be visible in their `cloud-config.yaml`.
