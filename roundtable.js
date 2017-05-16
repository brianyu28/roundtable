var viewWidth = 0;
var viewHeight;
var detailX;
var detailY;
var detailWidth;
var detailHeight;

var numPoints;
var circleSize;
var maxRadius;
var radius;
var selectedIndex = -1;
var centers_x = [];
var centers_y = [];
var points = [];

var currentDetail = []; // elements currently in detail view

window.onload = function() {
    var svg = setup();
    render(svg);
    showTitle(svg);
}

function setup() {

    numPoints = data.length;
    
    var canvas = d3.select('div#roundtable');
    canvas.style('width', px(enforcedWidth));

    curWidth = enforcedWidth;
    viewWidth = curWidth;
    viewHeight = viewWidth / aspectRatio;

    var svg = canvas.append('svg')
        .style('width', px(viewWidth))
        .style('height', px(viewHeight))

    circleSize = min(maxCircleSize, viewWidth / (numPoints + 3));
    maxRadius = circleSize + pulsationSize;
    for (var i = 0; i < numPoints; i++) {
        var proportion = i / (numPoints - 1);
        var coords = semicircleCoords(viewWidth, viewHeight, proportion);
        centers_x.push(coords[0]);
        centers_y.push(coords[1]);
    }

    var mainRadius = dist(viewWidth/2, viewHeight, circleSize, semicircleStart * viewHeight);
    detailHeight = mainRadius * Math.sin(Math.PI / 4);
    detailWidth = detailHeight * 2;
    detailX = (viewWidth / 2) - detailHeight;
    detailY = viewHeight - detailHeight;

    return svg;
}

function render(svg) {

    // fill background
    var background = svg.append('rect')
        .attr('x', 0)
        .attr('y', 0)
        .attr('width', viewWidth)
        .attr('height', viewHeight)
        .style('fill', bgColor);

    for (var i = 0; i < numPoints; i++) {
        radius = circleSize; // TODO pulsating
        var point = drawPoint(svg, i, radius);
        points.push(point);
    }
}

function drawPoint(svg, i, radius) {
    var additionalVerticalPadding = 0;

    if (i == selectedIndex) {
        // TODO: show glow
    }

    var point = svg.append('image')
        .attr('xlink:href', 'img/' + data[i]['image'])
        .attr('x', centers_x[i] - (radius / 2))
        .attr('y', centers_y[i] - (radius / 2))
        .attr('width', radius)
        .attr('height', radius);

    point.transition()
        .duration(i * 200)
        .on('end', animatePoint);

    point.on('click', function() {
        showDetail(svg, i);
    });

    function animatePoint() {
        // animate the point
        point.transition()
            .duration(1000)
            .attr('width', radius + pulsationSize)
            .attr('height', radius + pulsationSize)
            .attr('x', centers_x[i] - ((radius + pulsationSize) / 2))
            .attr('y', centers_y[i] - ((radius + pulsationSize) / 2))
            .ease(d3.easeLinear)
            .transition()
            .duration(1000)
            .attr('width', radius)
            .attr('height', radius)
            .attr('x', centers_x[i] - (radius / 2))
            .attr('y', centers_y[i] - (radius / 2))
            .ease(d3.easeLinear)
            .on('end', animatePoint);
    }

    // show text
    var label = svg.append('text')
        .attr('x', centers_x[i])
        .attr('y', centers_y[i] + (maxRadius / 2) + verticalLabelPadding + additionalVerticalPadding)
        .attr('width', maxRadius + 2 * horizontalLabelPadding)
        .attr('height', maxRadius)
        .style('font-family', mainFont)
        .style('font-size', labelFontSize)
        .style('fill', textColor)
        .style('text-anchor', 'middle')
        .text(function() { return data[i]['name']; });

    return point;
}

var glowList = [];
function showDetail(svg, i) {
    // don't do anything if clicked again
    if (selectedIndex === i) {
        return;
    }
    selectedIndex = i;

    // remove glow  
    for (var j = 0; j < glowList.length; j++) {
        glowList[j].remove();
    }
    glowList = [];

    // remove anything in detail view
    for (var j = 0; j < currentDetail.length; j++) {
        currentDetail[j].remove();
    }
    currentDetail = [];
    
    for (var j = 0; j < glowSize; j++) {
        var circleSize = (radius / 2) + j;
        glow = svg.insert('circle', 'image')
            .attr('cx', centers_x[i])
            .attr('cy', centers_y[i])
            .attr('r', (radius / 2) + j)
            .attr('stroke', glowColor)
            .attr('stroke-opacity', 1 - (j / glowSize))
            .attr('fill', 'none');
        glowList.push(glow); 
    }

    var headlineFontSize = boundBy(11 + (viewWidth / 40.0), 11, 36);

    // show person's name
    var name = svg.append('text')
        .attr('x', detailX + (detailWidth / 2))
        .attr('y', detailY + detailHeadPadding)
        .attr('width', detailWidth)
        .attr('height', 50)
        .attr('text-anchor', 'middle')
        .attr('fill', textColor)
        .attr('font-family', mainFont)
        .attr('font-size', px(headlineFontSize))
        .text(function() { return data[i]['name']; });
    currentDetail.push(name);

    // show person's image
    var imgX = detailX + detailHeadPadding;
    var imgY = detailY + boundBy(23 + (viewWidth / 15), 40, 90);
    var image = svg.append('image')
        .attr('xlink:href', 'img/' + data[i]['image'])
        .attr('x', imgX)
        .attr('y', imgY)
        .attr('width', 0.3 * detailWidth)
        .attr('height', 0.3 * detailWidth);
    currentDetail.push(image);

    // show description
    var description = svg.append('text')
        .attr('x', imgX + 0.4 * detailWidth)
        .attr('y', imgY)
        .attr('width', 0.5 * detailWidth)
        .attr('height', 0.3 * detailWidth)
        .attr('text-anchor', 'start')
        .attr('font-family', mainFont)
        .attr('font-size', px(descriptionFontSize))
        .attr('fill', textColor)
        .text(data[i]['description'])
        .call(wrap, 0.45 * detailWidth);
    currentDetail.push(description);

}

function showTitle(svg) {
    
    // show main headline
    var headline = svg.append('text')
        .attr('x', detailX + detailWidth / 2)
        .attr('y', detailY + 0.3 * detailHeight)
        .attr('width', detailWidth - 2 * detailHeadPadding)
        .attr('height', 0.7 * detailHeight)
        .attr('text-anchor', 'middle')
        .attr('font-family', mainFont)
        .attr('font-size', boundBy(11 + (viewWidth / 40), 11, 36))
        .attr('fill', textColor)
        .text(roundtableTitle);
    currentDetail.push(headline);

    // show instructions
    var instructionText = svg.append('text')
        .attr('x', detailX + detailWidth / 2)
        .attr('y', detailY + 0.7 * detailHeight)
        .attr('width', detailWidth - 2 * detailHeadPadding)
        .attr('height', 0.3 * detailHeight)
        .attr('text-anchor', 'middle')
        .attr('font-family', mainFont)
        .attr('font-size', descriptionFontSize)
        .attr('fill', textColor)
        .text(instructions);
    currentDetail.push(instructionText);
}
