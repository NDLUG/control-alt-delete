// Solution to Challenge 03 - Javascript (Node.js)
// Copyright (c) 2021 Daniel Blittschau

// Run with `node solution-dblitt.js < input.txt`

//const manifest = require('./MANIFEST.json');

let fs = require('fs');
let data = fs.readFileSync(0, 'utf-8');
const manifest = JSON.parse(data);

let dependencyCounter = 0;
// let dependencyCounter1 = 0;
let dependencies = [];
let dependencyNeedTracker = new Proxy({}, {
    get: (target, name) => name in target ? target[name] : 0
});
for (package in manifest) {
    for (let i = 0; i < manifest[package].length; i++) {
        dependencyNeedTracker[manifest[package][i]] ++;
    }
}
let terminalPackages = 0;

// for (let i = 0; i < manifest['jailbreak'].length; i++) {
//     if (dependencies.indexOf(manifest['jailbreak'][i]) !== -1) {
//         dependencies.push(manifest['jailbreak'][i]);
//         dependencyCounter1++;
//     }
// }

let depthsPackagesAreBuiltAt = []
checkDependenciesQueue = [];
// checkDependenciesQueue.push({newDependenciesToCheck: manifest['jailbreak'], depth: 0});
// we cant just use manifest[jailbreak] because since we counted the garbage packages that
// werent depens, we have to get rid of them

// put all the packages in that arent used by anything (i.e. jailbreak and all the garbage)
for (package in manifest) {
    if (dependencyNeedTracker[package] === 0) {
        checkDependenciesQueue.push({newDependenciesToCheck: manifest[package], depth: 0, isThisNotGarbage: package === 'jailbreak'});
    }
}

// function checkDependencies(newDependenciesToCheck, depth) {
while (checkDependenciesQueue.length > 0) {
    //console.log(depth);
    let {newDependenciesToCheck, depth, isThisNotGarbage} = checkDependenciesQueue.pop();
    if(isThisNotGarbage) depthsPackagesAreBuiltAt.push(depth)
    if (newDependenciesToCheck.length === 0) {
        terminalPackages++;
    }
    // if (depth === 0)
    // console.log(newDependenciesToCheck.length)
    for (let i = 0; i < newDependenciesToCheck.length; i++) {
        dependencyNeedTracker[newDependenciesToCheck[i]]--;
        if (dependencies.indexOf(newDependenciesToCheck[i]) === -1) {
            dependencies.push(newDependenciesToCheck[i]);
            // dependencyCounter++;
            // checkDependencies(manifest[newDependenciesToCheck[i]], depth + 1);
        }
        if (dependencyNeedTracker[newDependenciesToCheck[i]] === 0) {
            checkDependenciesQueue.push({newDependenciesToCheck: manifest[newDependenciesToCheck[i]], depth: depth + 1, isThisNotGarbage: isThisNotGarbage});
        }
    }
}

let counts = {}
for (const depth of depthsPackagesAreBuiltAt) {
    counts[depth] = counts[depth] ? counts[depth] + 1 : 1;
}
let possibleMaxConcurrencies = Object.values(counts);
let maxConcurrency = possibleMaxConcurrencies[0];
for (let i = 1; i < possibleMaxConcurrencies.length; i++) {
    if (possibleMaxConcurrencies[i] > maxConcurrency) {
        maxConcurrency = possibleMaxConcurrencies[i];
    }
}

// console.log(counts);
console.log('Number of Dependencies: ' + dependencies.length);
console.log('Maximum Concurrency: ' + maxConcurrency);
// console.log(dependencies.length)
// console.log(dependencyNeedTracker)
// console.log(dependencies);
// console.log(terminalPackages)

