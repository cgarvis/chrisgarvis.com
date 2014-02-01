---
layout: post
title: "Default Scope Values for Directives"
date: 2014-02-01 09:42:57 -0500
---

I was working on [angular-toggle-switch][ats] this morning,
and watching the `$attrs` or `$scope` to set default values seemed too much.
So I dug into the Angular docs
and I found that I could get the `attrs` in the `compile` function.
You can't do any interpolating at this stage,
but you can see if the attribute has been defined.
So instead of doing most of the work in a `link` function,
I'm now setting defaults in a `compile` function
and the logic in a `controller` function.

```
angular.module('directives', [])
    .directive 'myDirective', ->
        restrict: 'E'
        scope:
            foo: '=?'
        controller: ($scope, $log) ->
            $log.log($scope.foo)
        compile: (element, attrs) ->
            unless attrs.foo? then attrs.foo = 'bar'
```

```
<my-directive></my-directive>
<my-directive foo="'foo'"></my-directive>
```
If you do still need the `link` function,
remember that you have to return it from the `compile` function.

[ats]: https://github.com/cgarvis/angular-toggle-switch/
