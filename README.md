# arpm

arpm is the Arduino Package Manager, a simple way to keep track of all the libraries used in an Arduino project.

## Installation

Install it via RubyGems:

    $ gem install arpm

## Usage

There are two ways of installing libraries, much like with other package managers such as RubyGems. You can either install them by hand, and use arpm as an easy way of quickly installing libraries, or you can use the Libfile to keep track of which libraries a project requires and allows anyone else to install all of them by running a single command, `arpm bundle`.

### Bundle

Projects should have a Libfile in their root (the folder with the `.ino` sketch file in it), which looks something like:

```
lib "bergcloud", "1.0"
lib "time", "3.2"
```

Then, open a console in that directory and type:

    $ arpm bundle

This will read the list of dependencies and install them into your Arduino's library directory (`~/Documents/Arduino/libraries` on OS X and `~\My Documents\Arduino\libaries` on Windows).

### Manual Installing

Manually installing libraries is as simple as running a command. For the most recent version of a library, run:

    $ arpm install package_name

To specify a version, you can do this, for instance:

    $ arpm install package_name 1.0

## Registering a Library

So you've made a library and you want to get it on arpm? There are only 3 things you need to do:

1. Put the source code for the library on GitHub (or some other Git host, like BitBucket)
2. Create a release of your code with the tag of a version number (e.g. `1.0`)
3. Add your library to `packages.json`

### Putting Source Online

Push your source code to your favourite Git hosting site, and obtain an URL that looks like:

> https://github.com/bergcloud/devshield-arduino.git

### Create a Release

This is as simple as going to the releases tab of the site you use. For GitHub, it's:

> https://github.com/username/your-repository/releases

Then hit the 'Create a New Release' button, and put the version number in the `tag` box. Make sure your version number starts with a number, and is separated by dots. Version numbers cannot contain `-` however because the Arduino IDE doesn't like them.

For instance, `1.0`, `0.9.2` and `2.0.beta` are all valid version names.

### Adding to `packages.json`

First, fork this repository. Then edit the `packages.json` file, adding a section like this:

```
{
  "name": "bergcloud",
  "repository": "https://github.com/bergcloud/devshield-arduino.git",
  "authors": ["Nick Ludlam", "Andy Huntington"],
  "email": "info@bergcloud.com"
}
```
Note: the `name` cannot contain dashes (`-`) either because Arduino doesn't like them. It can only contain letters, numbers, and underscores.

Add the git URL you got earlier to the `repository` section.

Make sure that there's a comma on the end of the previous repository (`},`) and one on the end of yours if there are packages after it.

Then make a pull request, and if everything's fine, I'll merge it as soon as I can, and your package will go live.

## Contributing to Source

To contribute to the source of arpm:

1. Fork it (https://github.com/alfo/arpm/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
