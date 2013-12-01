---
layout: post
title: "Screw D3.js, Bar Charts in AngularJS"
date: 2013-12-01 15:21:31 -0500
---

In my [last post][my-d3-angular-post]
I showed how to integrate [D3.js][d3js] in with [AngularJS][angularjs]
After reading Alexandros [post][resin-d3-angular-post] this morning,
I got to wondering if I could build a bar chart in just Angular.
Well I'm here to say that it is possible.
It's also less code and easier to understand.

## Why not D3?

D3.js is amazing.
But at 146kb minized,
it's a bit heavy for just a bar chart.
It is also a [code smell][define-code-smell] to mix your interface and logic code.
Since I've started working with Angular,
I've found it easier and less work
if I just implement the solution using Angular.

## There's SVG in my directive

In this example we are going use a template
so we can use some of that amazing Angular data-binding.

```
angular.module('charts', [])
    .directive 'barChart', ->
        restrict: 'E'
        replace: true
        scope:
            dataset: '='
        template: '<svg></svg>'
```

We would like to have control over the width and height of the graph,
so lets add it to the template and scope.
You will notice that I've used `ng-attr-width` and `ng-attr-height`
instead of `width` and `height`.
It would seem that SVG elements are a bit more sensitive than other HTML5 elements.
Using `ng-attr` keeps the `width` and `height` attributes from being filled with invalid data.

```
{% raw %}
angular.module('chart', [])
    .directive 'barChart', ->
        template: '<svg ng-attr-width="{{graph.width}}" ng-attr-height="{{graph.height}}"></svg>'
        link: (scope, element, attrs) ->
            scope.graph =
                height: 200
                width: 400
{% endraw %}
```

To add bars to the graph,
we will use [SVG's `rect` element][svg-rect-doc]
in conjunction with `ng-repeat`.

```
{% raw %}
<svg ng-attr-width="{{graph.width}}" ng-attr-height="{{graph.height}}">
    <rect ng-repeat="data in dataset"></rect>
</svg>
{% endraw %}
```

To really get bars,
we need to use `width`, `height`, `x`, and `y` attributes on `rect`.

Width is just the graph width divide by the number of data points.
For height,
we need to find the max value in the dataset
so we can determine what percentage of the height the bar should be.

```
scope.width = ->
    dataPoints = scope.dataset.length
    scope.graph / dataPoints

scope.height = (data) ->
    max = Math.max.apply(null, scope.dataset)
    data / max * scope.graph.height
```

Next we need to place the bars on the graph.
Due to how SVG works,
we need to find the `x` and `y` coordinates
for the top left corner of each bar.
Since we will be place this allow the x-axis,
`x` will be a multiple of the bar width.
For `y` we need to calculate the distance between the top of the graph and the bar.

```
scope.x = (index) ->
    index * scope.width()

scope.y = (data) ->
    scope.graph.height - scope.height(data)
```

Now we can wire up our template with our new functions.

```
{% raw %}
<svg ng-attr-width="{{graph.width}}" ng-attr-height="{{graph.height}}">
    <rect ng-repeat="data in dataset"
        ng-attr-width="{{width()}}"
        ng-attr-height="{{height(data)}}"
        ng-attr-x="{{x($index)}}"
        ng-attr-y="{{y(data)}}">
    </rect>
</svg>
{% endraw %}
```

The end result is a terse and declartive solution.
I don't know about you,
but SVG doesn't seem that hard.

[angularjs]: http://angularjs.org/
[coffee]: http://coffeescript.org/
[d3js]: http://d3js.org/
[define-code-smell]: http://en.wikipedia.org/wiki/Code_smell
[my-d3-angular-post]: /blog/building-d3-bar-chart-for-angular.html
[resin-d3-angular-post]: http://alexandros.resin.io/angular-d3-svg/
[svg-rect-doc]: http://www.w3.org/TR/SVG/shapes.html#RectElement
