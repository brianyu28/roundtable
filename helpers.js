function dist(x1, y1, x2, y2) {
    var a = x1 - x2;
    var b = y1 - y2;
    return Math.sqrt(a*a + b*b);
}

// gets the coordiantes of a point on semicircle 
function semicircleCoords(width, height, proportion) {

    // origin of the cicle
    var originX = width / 2;
    var originY = height;
    
    // leftmost and rightmost points along semicircle
    var leftmostX = circleSize;
    var leftmostY = semicircleStart * height;
    var rightmostX = width - circleSize;
    
    // angle and distance from origin to leftmost and rightmost angles
    var leftAngle = Math.atan((originY - leftmostY) / (originX - leftmostX));
    var rightAngle = Math.PI - leftAngle;
    var semicircleRadius = dist(originX, originY, leftmostX, leftmostY);

    // compute desired angle
    var desiredAngle = (proportion * (rightAngle - leftAngle)) + leftAngle;

    // compute desired x and y values
    var x = originX - semicircleRadius * Math.cos(desiredAngle);
    var y = originY - semicircleRadius * Math.sin(desiredAngle);
    
    return [x, y];
}

function boundBy(x, lower, upper) {
    if (x < lower)
        return lower;
    else if (x > upper)
        return upper;
    else
        return x;
}

function px(x) {
    return x + 'px';
}

function min(a, b) {
    return a < b ? a : b;
}

function wrap(text, width) {
    text.each(function () {
        var text = d3.select(this),
            words = text.text().split(/\s+/).reverse(),
            word,
            line = [],
            lineNumber = 0,
            lineHeight = 1.1, // ems
            x = text.attr("x"),
            y = text.attr("y"),
            dy = 0, //parseFloat(text.attr("dy")),
            tspan = text.text(null)
                        .append("tspan")
                        .attr("x", x)
                        .attr("y", y)
                        .attr("dy", dy + "em");
        while (word = words.pop()) {
            line.push(word);
            tspan.text(line.join(" "));
            if (tspan.node().getComputedTextLength() > width) {
                line.pop();
                tspan.text(line.join(" "));
                line = [word];
                tspan = text.append("tspan")
                            .attr("x", x)
                            .attr("y", y)
                            .attr("dy", ++lineNumber * lineHeight + dy + "em")
                            .text(word);
            }
        }
    });
}
