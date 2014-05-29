# Serverspec minor mode

## Requirement

- yasnippet
- helm
- auto-comolete

## Installation

It's available on [Melpa](http://melpa.milkbox.net/)

    M-x package-install serverspec

## Usage

### Enable minor mode

    M-x serverspec

or hook

    (add-hook 'ruby-mode-hook '(lambda () (serverspec 1)))

### Functions

#### serverspec::find-spec-files

List up `*_spec.rb` files.

### Snippets for yasnippet

- Serverspec resource types snippet

### Dictionary for auto-complete

- Serverspec matcher dictionary

## File check test

[![Build Status](https://travis-ci.org/k1LoW/emacs-serverspec.svg?branch=master)](https://travis-ci.org/k1LoW/emacs-serverspec)
