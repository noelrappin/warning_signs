# Warning Signs ⚠️⚠️

The Warning Signs gem builds upon the ideas of the
[Ruby Warning Gem](https://github.com/jeremyevans/ruby-warning) 
and [Stop ignoring your Rails (and Ruby) deprecations!](https://blog.testdouble.com/posts/2023-04-24-stop-ignoring-your-ruby-and-rails-deprecations/).

The idea is to provide an easily-configurable way to manage deprecation 
warnings from Ruby and Rails to support your upgrades.

## Installing Warning Signs

To install Warning Signs add

`gem "warning_signs"`

to your gemfile, you will most likely want it to be in all environments, but 
under some use cases, you may not need it in production.

## Using Warning Signs

The Warning Signs gem looks for a `.warning_signs.yml` file when the Rails
application starts. If it does not find the file, it will not load and the 
processing of deprecations will be unaffected.

You should remove any environment settings in Rails that are managing 
`config.active_support.deprecation`, or at least those that are not
set to `:notify` -- use WarningSigns to handle those settings...

Warning Signs  allows you to define _handlers_ in the YAML file. A handler 
consists of the following:

* Patterns to match, which can be specified with `only` to match the 
  patterns specified and no others, or with `except` to match all patterns 
  except the given ones. If no patterns are specified, all patterns match.
* A source, either `ruby` for deprecations triggered with Ruby's `Warn` 
  module, or `rails` for deprecations triggered with Rails' 
  `ActiveSupport::Deprecation`. If a source is not specified, the handler 
  matches both sources.
* Environments and behaviors. An environment is either the name of a Rails 
  environment, the special word `all` which matches all environments, or the 
  special word `other`, which matches any environment not specifically  
  invoked. 
* Each environment can specify one or more behaviors:
  * `log` sends a message to the Rails logger
  * `stderr` sends a message to the standard error stream
  * `raise` raises an exception
  * `ignore` does nothing

Handlers are matched in order. If no handler applies to a deprecation 
warning, Ruby warnings is ignored, Rails warnings are passed through
the ActiveSupport notification mechanism.

The following example logs all deprecation warnings:

```yaml
handlers:
  - environment: all
    behavior: log
```

Multiple environments need to be handled in a nested list. This example 
raises exceptions in the test environment, but logs in other environments

```yaml
handlers:
  - environments:
      - environment: test
        behavior: raise
      - environment: other
        behavior: log
```

This example raises exceptions for Ruby deprecations, but ignores Rails 
deprecations:

```yaml
handlers:
  - source: ruby
    environment: all
    behavior: raise
  - source: rails
    environment: all
    behavior: ignore
```

A single environment can have multiple behaviors. This is helpful if you are,
say dealing with end-to-end specs that swallow exceptions:

```yaml
handlers:
  - environment: all
    behaviors: 
      - raise
      - log
```

No matter what order you have the behaviors in, a `raise` behavior will be 
executed last so that the other behaviors happen before the exception is 
invoked.

The attribute `backtrace_lines` can be used to print extra lines of the 
backtrace to the output for the `log`, `stderr`, and `stdout` behaviors. 
Currently, it's one attribute that applies to all behaviors. This can be 
useful, especially if the direct cause of the issue is in a gem.

```yaml
handlers:
  - environment: all
    backtrace_lines: 5
    behaviors: 
      - raise
      - log
```

A common pattern is to focus only on specific deprecations and ignore others.
For example, this setting file would raise on Ruby keyword argument 
deprecations and ignore other ruby deprecations

```yaml
handlers:
  - source: ruby
    only:
      - "Using the last argument as keyword parameters is deprecated"
      - "Passing the keyword argument as the last hash parameter is deprecated"
      - "Splitting the last argument into positional and keyword parameters is deprecated"
    environment: all
    behavior: log
```

Patterns are matched if the deprecation message contains the pattern as a 
substring.

The pattern can be a regular expression, denoted by using regular expression 
syntax _inside_ the string in the YAML:

```yaml
handlers:
  - source: ruby
    only:
      - "/Using .* argument/"
    environment: all
    behavior: log
```

The pattern inside the slashes is converted to a Ruby `Regexp` and patterns 
are matched if the regexp and the deprecation warning message match.

Another pattern is to have a list of ignored deprecations and then remove 
messages one by one and manage them individually.

In this case, the `except` pattern is used to excuse those known patterns 
from the list. Other patterns will raise in test, or log in other environments. 

```yaml
handlers:
  - source: rails
    except:
      - "Class level methods will no longer inherit scoping from `create!` in"
      - "Uniqueness validator will no longer enforce case sensitive comparison"
      - "app/models/user.rb"
    environments:
      - environment: test
        behavior: raise
      - environment: other
        behavior: log
```

Ruby warnings can have an optional category, there are two predefined 
categories, `deprecated` and `experimental`. You can specify a handler to 
match those categories based on an "only" or "except" matcher. If you want 
to specially handle warnings that do not have a defined category, you can 
refer to them as `blank`.

This handler only handles Ruby warnings that are deprecated, other warnings 
are ignored.

```yaml
handlers:
  - environment: all
    ruby_warnings:
      only:
        - deprecated
    behavior: log
```

This handler handles any Ruby warning with a category

```yaml
handlers:
  - environment: all
    ruby_warnings:
      except:
        - blank
    behavior: log
```

## To Do:

* Ability to customize output message format
