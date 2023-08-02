# Steno Elm Examples

This is the codebase for my implementation of some [Elm Examples][], created
using [Plover][] stenography and [UltiSnips][] snippets,
for the [Steno Coding: Elm Examples][] video.

Artefacts from the steno demo itself can be found in the [`demo/`][] directory.

## Dependencies

- [Elm][] 0.19.1

During the demo, I used [Elm-go][] to run the development servers.

## Setup

```sh
git clone https://github.com/paulfioravanti/steno-elm-examples.git
cd steno-elm-examples
```

If you are planning to use Elm-go, it can be installed via [npm][] directly from
its GitHub repo:

```sh
npm install --global https://github.com/lucamug/elm-go
```

## Run

Within any of the app directories, you can run the `elm-go` command to run a
development server. For example, if you want to run the `buttons` app, you can
do the following:

```sh
cd buttons
elm-go src/Main.elm -- --debug
```

Then, open <http://localhost:8000> in a web browser.

If you are a [Tmuxinator][] user, and want to run all the apps at once, like I
did in the demo, you may find my project [Tmuxinator config file][] of some
reference.

[`demo/`]: ./demo
[Elm]: https://elm-lang.org/
[Elm Examples]: https://elm-lang.org/examples
[Elm-go]: https://github.com/lucamug/elm-go
[npm]: https://www.npmjs.com/
[Plover]: http://www.openstenoproject.org/
[Steno Coding: Elm Examples]: https://www.youtube.com/watch?v=BNvpZ6wmkU4
[Tmuxinator]: https://github.com/tmuxinator/tmuxinator
[Tmuxinator config file]: https://github.com/paulfioravanti/dotfiles/blob/0a275b8bf8754958c9fd8fda7ae61735138d29fb/tmuxinator/elm-examples.yml
[UltiSnips]: https://github.com/SirVer/ultisnips
