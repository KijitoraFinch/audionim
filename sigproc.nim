import std/complex
import std/math
import std/stats


proc simpleFFTr(target: var seq[Complex64], invert_constant: float = 1.0): int =
  let N = target.len
  if N == 1:
    return 1

  else:
    var ev = newSeq[Complex64](N div 2)
    var od = newSeq[Complex64](N div 2)

    for i in 0..<N:
      if i mod 2 == 0:
        ev[i div 2] = target[i]
      else:
        od[i div 2] = target[i]

    discard ev.simpleFFTr
    discard od.simpleFFTr

    let base_angle = 2 * PI * invert_constant

    let N_half = N div 2

    for j in 0..<N:
      target[j] = ev[j mod N_half] + od[j mod N_half] * exp(complex(0.0, base_angle*(j.float/N.float)))
    return 1


func simpleFFT(sequence: seq[Complex64], invert: float = 1.0): seq[Complex64] =
  var res = sequence
  discard res.simpleFFTr(invert)
  return res


func resample(spectrum: seq[float], n: int): seq[float] =
  let segmentSize = (spectrum.len / n).int
  result = newSeq[float](n)
  for i in 0..n-1:
    let start_i = i * segmentSize
    let end_i = min((i + 1) * segmentSize, spectrum.len)
    result[i] = spectrum[start_i ..< end_i].mean

func multScalar(target: seq[float], scalar: float): seq[float] = 
  for t in target:
    result.add(t*scalar)
  



