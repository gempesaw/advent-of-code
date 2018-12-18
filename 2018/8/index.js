const fs = require('fs');

const string = fs.readFileSync(`${__dirname}/input`, 'utf-8');
// const string = '2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2';
// const string = '1 1 0 1 8 9';
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

const parseImmutable = ({
  input = [],
  node = { children: [], metadata: [] },
  remainingChildren = 0,
  remainingMetadata = 0
}) => {
  // console.log({ input, node, remainingChildren, remainingMetadata });
  if (remainingChildren > 0) {
    const [ child, rest ] = parseImmutable({ input, node });

    return parseImmutable({
      input: rest,
      node: { children: node.children.concat(child), metadata: [] },
      remainingChildren: remainingChildren - 1,
      remainingMetadata
    });
  }

  if (remainingMetadata > 0) {
    const metadata = input.slice(0, remainingMetadata);
    const rest = input.slice(remainingMetadata);

    return [
      { ...node, metadata },
      rest
    ];
  }

  const [ childCount, metadataCount, ...rest ] = input;

  if (!rest.length) {
    return [ node, input ];
  }

  return parseImmutable({
    input: rest,
    remainingChildren: childCount,
    remainingMetadata: metadataCount
  });
};

const getNodes = ({ children = [], metadata = [] }, acc = []) => {
  if (children.length) {
    children.forEach((child) => getNodes(child, acc));
  }

  acc.push({ children, metadata });
  return acc;
};

const getValue = ({ children = [], metadata = [] }) => {
  if (!children.length) {
    return metadata.reduce((a, b) => a + b, 0);
  }

  const childNodes = metadata.map((index) => children[index - 1])
    .filter(Boolean);

  return childNodes.reduce((acc, node) => acc + getValue(node), 0);
};

// const [ tree ] = parse(input);
const [ tree ] = parseImmutable({ input });
const nodes = getNodes(tree);
const metadata = nodes.reduce((acc, { metadata }) => acc.concat(metadata), []);

console.log(`1: ${metadata.reduce((a, b) => a + b, 0)}`);
console.log(`2: ${getValue(tree)}`);
// 1: 41760
// 2: 25737
