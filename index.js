//1.
var csv = require('csv');
//2.
var obj = csv();
//3.
var dataInfo = [
    ['101', 'MS', 100000],
    ['102', 'LS', 80000],
    ['103', 'TS', 60000],
    ['104', 'VB', 200000],
    ['105', 'PB', 180000],
    ['106', 'AB', 160000]
];
 
//4.
obj.from.array(dataInfo).to.path('dataInfo.csv');