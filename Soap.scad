
module hexagone(apothemLength) {
    angle = 360 / 6;
    
    coords = [
        for (i = [0:5]) [ apothemLength * cos(i * 60), apothemLength * sin(i * 60) ]
    ];
    
    polygon(coords);
}

module honeycomb_cell(apothemLength, thickness) {
    difference() {
        hexagone(apothemLength);

        hexagone(apothemLength - thickness);
    }
}

module honeycomb(rowCount, columnCount, cellApothemLength, thickness, center = true) {
    offsetX = cellApothemLength + cellApothemLength * 0.5 - thickness * 0.5;
    offsetY = cos(30) * cellApothemLength - thickness * 0.5;

    centerX = -rowCount * 0.5 * offsetX + offsetX * 0.5;
    centerY = -columnCount * 0.5 * offsetY * 2 + offsetY;

    union() {
        translate([centerX, centerY,  0]) {
            for (i = [0:rowCount-1]) {
                for (j = [0:columnCount-1]) {
                    if ((i % 2) == 0) {
                        translate([i * offsetX, j * offsetY * 2, 0]) {
                            honeycomb_cell(cellApothemLength, thickness);
                        }
                    } else {
                        translate([i * offsetX, j * offsetY * 2 + offsetY, 0]) {
                            honeycomb_cell(cellApothemLength, thickness);
                        }
                    }
                }
            }
        }
    }
}

module soap_grid(size, depth, fillPercent) {
    length = size * 0.5;
    cellApothemLength = length * fillPercent;
    rowCount = size / cellApothemLength;
    sphereRadius = size + size;
    sphereZ = sphereRadius + depth * 0.5;

    difference() {
        linear_extrude(depth) {
            union() {
                intersection() {
                    hexagone(length);
                    honeycomb(rowCount, rowCount, cellApothemLength, 3);
                }

                honeycomb_cell(length, 6);
            }
        }

        translate([ 0, 0, sphereZ]) {
            sphere(sphereRadius);
        }
    }
}

module soap_box(size, depth, depthGrid, thickness) {
    length = size * 0.5;

    union() {
        linear_extrude(thickness) {
            hexagone(length + 1 + thickness, thickness);
        }

        linear_extrude(depth) {
            honeycomb_cell(length + 1 + thickness, thickness);
        }

        linear_extrude(depth - depthGrid) {
            honeycomb_cell(length + 2, thickness);
        }
    }
}

//soap_box(120, 25, 10, 6);
//translate([0, 0, 50]) {
    soap_grid(120, 10, 0.175);
//}