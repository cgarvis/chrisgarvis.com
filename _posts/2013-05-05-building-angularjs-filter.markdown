---
layout: post
title: "How to Build an AngularJS Filter"
date: 2013-05-05 12:16:50 -0400
tags: AngularJS, Javascript
---

I have recently been working with [AngularJS](http://angularjs.org "AngularJS — Superheroic JavaScript MVW Framework")
and I have to say,
I haven't felt this productive since Rails.
I'm a bit of an [architecture](http://www.youtube.com/watch?v=WpkDN78P884 "Architecture the Lost Years by Robert Martin") nut
and AngularJS gives me all the building blocks
to build a well structured application.

The first building block that everyone learns are filters.
They are one of a few ways to get presentation logic out of your business logic.
Filters format data to be displayed to the user.
In this post,
I will show you how to build a simple phone number filter.
But first lets see how filters would work.

## Understanding AngularJS Filters

Filters are functions that are passed an expression.
They are written like this:

```coffeescript
{% raw %}
{{ expression | filter }}
{% endraw %}
```

Real examples are always better:

```coffeescript
{% raw %}
{{ name | uppercase }}
{% endraw %}
```

## 1. Create the scaffolding.

In AngularJS,
it is best to build a bunch of smaller modules
and then craft them together to build a larger application.
Not only does this make it easier to test,
but it becomes very easy to reuse components.
Following that matra,
we will build filter as a standalone module.

A filter is just a function that is executed on some input.
So this is all that is needed:

```coffeescript
# Important: modules need a 2nd parameter even if it's an empty array
angular.module('telephone', [])
  .filter 'telephone', ->
    (input) ->
      input
```

## 2. Create the tests.

AngularJS was built from the ground up with testing in mind.
There are two types of tests in AngularJS, [Unit](http://docs.angularjs.org/guide/dev_guide.unit-testing "AngularJS - Unit Testings") and [End-2-End](http://docs.angularjs.org/guide/dev_guide.e2e-testing "AngularJS - E2E") (e2e).
For our purposes,
unit tests will be enough.

Write tests from the beginning.
You will thank me later.

```coffeescript
describe 'Filter: Telephone', ->
  filter = {}

  # Load up just the module
  beforeEach module('telephone')

  # Instantiate the filter
  beforeEach inject ($filter) ->
    filter = $filter('telephone')

  it 'exists', ->
    expect(filter).not.toBe(null)

  it 'returns empty string when given null', ->
    number = filter(null)
    expect(number).toEqual('')

  it 'returns formatted telephone number when given 10 digits', () ->
    number = filter('1234567890')
    expect(number).toEqual('(123) 456-7890')
```

Here we are using [Jasmine](http://pivotal.github.io/jasmine/).
If you are not familiar with Jasmine,
you can find a list of matchers on their [wiki](https://github.com/pivotal/jasmine/wiki/Matchers)

## 3. Build the filter

```coffeescript
angular.module('telephone', [])
  .filter 'telephone', () ->
    (input) ->
      number = input || ''

      # Clean up input by removing whitespaces and unnessary chars
      number = number.trim().replace(/[-\s\(\)]/g, '')

      if number.length is 10
        area = "(#{number[0..2]})"
        local = "#{number[3..5]}-#{number[6...]}"

        # (111) 111-1111
        number = "#{area} #{local}"

      number
```

## 5. Install the filter

```html
<script src="/scripts/filters/telephone.js"></script>
```

Add the filter as a dependency

```coffeescript
angular.module('App', ['telephone'])
```

## 6. Profit!

Once installed and setted as a dependency,
we can use it in any of our views.

```html
{% raw %}
<table>
  <tr ng-repeat="contact in contacts">
    <td>{{contact.name}}</td>
    <td>{{contact.number | telephone}}</td>
  <tr>
</table>
{% endraw %}
```
