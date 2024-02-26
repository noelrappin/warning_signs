## 0.7.2 Feb 26, 2024

* For some reason, now need to explicitly require active_support/subscriber

## 0.7.1 Jan 26, 2024

* Unneeded reference to awesome_print removed

## 0.7.0 Jan 22, 2024

* Dropped matrix testing for Ruby 2.7
* Added matrix testing for Ruby 3.3
* Added support for Rails 7.1

## 0.6.1 Dec 15, 2023

* Warning Signs error message makes it clearer that Warning Signs is 
  triggering the error

## 0.6.0

* Allow for format options in messages
* Allow for filter options in backtrace
* Allow for multiple output behaviors based on environment

## 0.5.1

* Better filtering of backtraces 

## 0.5.0

* Allow handlers to print out backtraces for log, stdout, and stderr behaviors

## 0.4.0

* Allow handlers to take into account Ruby warning categories
* Ruby warning message better handles Ruby warning categories

## 0.3.0

* Allow multiple behaviors in a single environment
* Allow only and except matchers to be regular expressions

## 0.2.0

* Test for "other environment"

## 0.1.0

* Smarter caller information for Ruby warnings

## 0.0.1

* Initial public release
