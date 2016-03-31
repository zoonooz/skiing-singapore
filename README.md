# Skiing in Singapore

Try to solve the problem at [http://geeks.redmart.com/2015/01/07/skiing-in-singapore-a-coding-diversion/](http://geeks.redmart.com/2015/01/07/skiing-in-singapore-a-coding-diversion/)

#### 1. Transform txt file to array
Sample data from source
```
[
  ["4", "8", "7", "3"],
  ["2", "5", "9", "3"],
  ["6", "3", "2", "5"],
  ["4", "4", "1", "6"]
]
```

#### 2. Find the in-out directions of every node and store back to array
The result is the the length and the different between first and last node values, so I don't have to care about the value along the path if it is not the first node.

```
[
  ["←,↓,?,?",  "8",         "↑→,→,?,?",  "→,,1,3"],
  ["↓←↑,,1,2", "↓←,↓←,?,?", "9",         "↑→,,1,3"],
  ["6",        "↓↑→,→,?,?", "↓←→,↓,?,?", "↑,↑←,?,?"],
  ["↓,,1,4",   "4",         "↓←→,,1,1",  "6"]
]
```

I store the new value in format `{a, b, c, d}`
- **a** -> possible coming directions
- **b** -> possible going directions
- **c** -> number of nodes to last node
- **d** -> last node value

Only last node will have **c** and **d** value at this stage, `?` indicate that currently is unknown

#### 3. Start from the number
Node that does not have the way to go higher will be the starting point. After started with `"8"` the array will looks like this

```
[
  ["←,↓,2,2",  "8",         "↑→,→,2,3",  "→,,1,3"],
  ["↓←↑,,1,2", "↓←,↓←,4,1", "9",         "↑→,,1,3"],
  ["6",        "↓↑→,→,3,1", "↓←→,↓,2,1", "↑,↑←,?,?"],
  ["↓,,1,4",   "4",         "↓←→,,1,1",  "6"]
]
```

Next time when run `"9"` it will not run all the previous paths again, just use the stored values.

#### 4. Compare every number paths
The final array is
```
[
  ["←,↓,2,2",  "8",         "↑→,→,2,3",  "→,,1,3"],
  ["↓←↑,,1,2", "↓←,↓←,4,1", "9",         "↑→,,1,3"],
  ["6",        "↓↑→,→,3,1", "↓←→,↓,2,1", "↑,↑←,3,1"],
  ["↓,,1,4",   "4",         "↓←→,,1,1",  "6"]
]
```

Take a look at `"9"` the most longest length is `"↓←,↓←,4,1"` so the result is
```
length: 4 + 1 = 5 // plus 1 for 9 itself
size: 9 - 1 = 8
```
