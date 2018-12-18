const fs = require('fs');

const string = fs.readFileSync(`${__dirname}/input`, 'utf-8');
// const string = '2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2';

const input = string.split(' ').map(Number);

const parse = (input, node = { children: [], metadata: [] }, remainingChildren = 0) => {
  let [ childCount, metadataCount, ...rest ] = input;

  let child;
  while (childCount > 0) {
    ([ child, rest ] = parse(rest));
    node.children.push(child);
    --childCount;
  }

  node.metadata = rest.slice(0, metadataCount);
  rest = rest.slice(metadataCount);

  return [ node, rest ];
};

const getNodes = ({ children = [], metadata = [] }, acc = []) => {
  if (children.length) {
    children.forEach((child) => getNodes(child, acc));
  }

  acc.push({ children, metadata });
  return acc;
};

const [ tree ] = parse(input);
const nodes = getNodes(tree);
const metadata = nodes.reduce((acc, { metadata }) => acc.concat(metadata), []);

console.log(`1: ${metadata.reduce((a, b) => a + b, 0)}`);
