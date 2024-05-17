include sigproc
import os
import strutils
import algorithm
import sequtils
import terminal
import rdstdin


proc visualize(spct: seq[float], symbol: char = '#'): seq[string] = 
  var bars = newSeq[seq[char]](spct.len)
  for j, val in spct:
    bars[j] = concat(repeat[char](symbol, val.int), repeat[char](' ', spct.max.int - val.int))
  
  var result_matrix = newSeq[seq[char]](spct.max.int)
  for r in 0..<result_matrix.len:
    result_matrix[r] = repeat[char](' ',spct.len)

  bars = reversed bars
  for r in 0..<len bars:
    for c in 0..<len bars[r]:
      result_matrix[c][r] = bars[r][c]
  
  result = newSeq[string](spct.max.int)

  for r in 0..<result_matrix.len:
    result[r] = result_matrix[r].join("")

  result = reversed result


proc dispScreen(target: seq[string]): void = 
  echo target.join "\n"


proc main() =
  hideCursor()
  eraseScreen()
  while true:
    var line = readLine(stdin)
    if line == "":
      break
    var inpt = line.split.map(parseFloat)
    let spct = inpt.mapIt(complex(it)).simpleFFT.mapIt(it.abs)
    let output = spct.resample(terminalWidth()).visualize()

    dispScreen(output)

main()

