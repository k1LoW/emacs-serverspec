# Serverspec minor mode

## Requirement

- yasnippet
- helm
- auto-comolete

## Installation

It's available on [Melpa](http://melpa.milkbox.net/)

    M-x package-install serverspec

## Enable minor mode

    M-x serverspec

or hook

    (add-hook 'ruby-mode-hook '(lambda () (serverspec 1)))

## Functions

### `serverspec::find-spec-files`

List up `*_spec.rb` files.

## Snippets for yasnippet

- Serverspec resource types snippet

## Dictionary for auto-complete

- Serverspec matcher dictionary
