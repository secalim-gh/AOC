const fs = require('fs');

interface AdjacencyMap {
  [key: string]: Device;
}

class Device {
  name: string;
  links: Device[];
  walked: boolean;
  steps: number;

  constructor(name: string) {
    this.name = name;
    this.links = [];
    this.walked = false;
    this.steps = 0;
  }
}

function parseFile(filePath: string, map: AdjacencyMap) {
  const fileContent: string = fs.readFileSync(filePath, 'utf-8');
  const lines: string[] = fileContent.trim().split('\n');

  const getOrCreateNode = (name: string): Device => {
    if (!map[name]) {
      map[name] = new Device(name);
    }
    return map[name];
  };

  for (const line of lines) {
    const parts = line.split(':');

    if (parts.length !== 2) continue; 

    const sourceName = parts[0].trim();
    const targetNames = parts[1].trim().split(/\s+/).filter(Boolean); 
    const sourceNode = getOrCreateNode(sourceName);

    for (const targetName of targetNames) {
      const targetNode = getOrCreateNode(targetName);
      sourceNode.links.push(targetNode);
    }
  }
}

const filePath = process.argv[2];

if (!filePath) {
  console.error('Please provide filepath');
  process.exit(1);
}

function countPaths(start: Device): number {
  if (start.walked) return start.steps;
  if (start.name === 'out') {
    start.walked = true;
    start.steps = 1;
    return 1;
  }

  start.links.forEach(element => {
    start.steps += countPaths(element);
  });
  start.walked = true;
  return start.steps;
}

function countServerPaths(start: Device, needsDAC: boolean, needsFFT: boolean, memo: Map<string, number>): number {
  const memoKey = `${start.name}_${needsDAC}_${needsFFT}`;

  if (memo.has(memoKey)) {
    return memo.get(memoKey)!;
  }

  if (start.name === 'out') {
    const result = needsDAC === false && needsFFT === false ? 1 : 0;
    memo.set(memoKey, result);
    return result;
  }

  let nextNeedsDAC = needsDAC;
  let nextNeedsFFT = needsFFT;

  if (start.name === 'dac') {
    nextNeedsDAC = false;
  }
  if (start.name === 'fft') {
    nextNeedsFFT = false;
  }

  let totalPaths = 0;
  for (const element of start.links) {
    totalPaths += countServerPaths(element, nextNeedsDAC, nextNeedsFFT, memo);
  }

  memo.set(memoKey, totalPaths);
  return totalPaths;
}

try {
  const map: AdjacencyMap = {};
  parseFile(filePath, map);
  const you: Device = map['you'];
  const svr: Device = map['svr'];

  const memo = new Map<string, number>();

  console.log(`There are ${countPaths(you)} paths from you`);
  console.log(`There are ${countServerPaths(svr, true, true, memo)} valid paths from svr`);

} catch (error) {
  console.error((error as Error).message);
  process.exit(1);
}
