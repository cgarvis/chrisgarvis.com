---
layout: post
title: "Building D3 Bar Chart for Angular"
date: 2013-10-10 10:03:45 -0400
---

D3 a very powerful tool
and at times can be a bit overwhelming.
Today I would like to simplify things
by walking you through building a bar chart using D3.

![Demo Bar Chart][d3-bar-chart]

**tl;dr** Full version [gist][gist].

### Warning Coffeescript

The example is written in [CoffeeScript][coffee] as I find it much easier to read
and write than javascript.

## In the beginning there was a directive

First step is to create a `barChart` directive.

It will will take an `data` array
and add a `svg` tag to our element.
We will using this svg to build our chart.

```
angular.module('chart', [])
    .directive 'barChart', ->
        restrict: 'E'
        scope:
            data: '='
        link: (scope, element, attrs) ->
            width = 400
            height = 200

            chart = d3.select(element[0])
                .append("svg:svg")
                .attr("width", width)
                .attr("height", height)
```

## Barebone bar chart

D3 allow us to resize our data
to the portions of the SVG using `d3.scale`.
We tell the scale the upper and lower bounds of the dataset using `domain`
and the upper and lower bounds of the chart using `range`.
Using `x` and `y` functions generated from `d3.scale.linear()`,
we can then place bars in the right spot on the SVG.

```
angular.module('chart')
    .directive 'barChart', ->
        link: (scope, element, attrs) ->

            // Append SVG

            draw = (data) ->
                barWidth = width / (data.length + 1)

                x = d3.scale.linear().domain([0, data.length]).range([0, width])
                y = d3.scale.linear().domain([0, d3.max(data)]).rangeRound([0, height])

                chart.selectAll("rect")
                        .data(data)
                    .enter().append("svg:rect")
                        .attr("x", (datum, index) -> x(index))
                        .attr("y", (datum, index) -> height - y(datum))
                        .attr("height", (datum, index) -> y(datum))
                        .attr("width", barWidth)
                        .attr("fill", "#2d578b")
```

## No chart is complete without labels

The formal [SVG Text][svg-spec] spec is not for the faint of heart.
Only the most ambitious typographers require that level of control.
We only need to understand `dx`, `dy`, and `text-anchor`.

For the web developers out there,
here is a quick guide:

* `dx` is `padding-left`
* `dy` is `padding-top`
* `text-anchor` is `text-align`

```
            draw = (data) ->
                // Add rects

                chart.selectAll("text")
                        .data(data)
                    .enter().append("svg:text")
                        .attr("x", (datum, index) -> x(index) + barWidth)
                        .attr("y", (datum) -> height - y(datum))
                        .attr("dx", -barWidth/2)
                        .attr("dy", "1.2em") 
                        .attr("text-anchor", "middle")
                        .text((datum) -> datum)
                        .attr("fill", "white")
```

Using what we learned from adding a label to each bar,
we can do the same with the labels for the Y axis.

```
            draw = (data) ->
                // Add rects

                // Add bar labels

                chart.selectAll("text.yAxis")
                        .data(data)
                    .enter().append("svg:text")
                        .attr("x", (datum, index) -> x(index) + barWidth)
                        .attr("y", height)
                        .attr("dx", -barWidth/2)
                        .attr("dy", "1.2em")
                        .attr("text-anchor", "middle")
                        .attr("style", "font-size: 12; font-family: Helvetica, sans-serif")
                        .text((datum, index) -> index + 1)
                        .attr("class", "yAxis")
```

## But I AngularJS magic!

Now for the Angular bit.
We want our chart to change when the data changes.
To do so,
lets add a `$watch` on `data`.
If data has changed,
we remove all the elements from the svg
and redraw the graph.

```
angular.module('chart')
    .directive 'barChart', ->
        link: (scope, element, attrs) ->

            // Append SVG

            // Draw function

            scope.$watch 'data', (data) ->
                if data?
                    chart.selectAll("*").remove()
                    draw(data)

```

## Are you done yet?

Add this little snippet to your template and away you go!

```
<barchart data="[3,5,1,6,2,7,8,3,1,6,4]"></barchart>
```

D3 isn't so scary anymore right?
You can find the full version in a [gist][gist].

[coffee]: http://coffeescript.org/
[d3-bar-chart]: /img/d3-bar-chart.png
[gist]: https://gist.github.com/cgarvis/71a3e2ab7ac0fe59796e
[svg-spec]: http://www.w3.org/TR/SVG/text.html