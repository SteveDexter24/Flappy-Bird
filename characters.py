def charScale(array, height, width, scale):
  write = ""
  temp_w = ""
  arr =[]
  for i in range(height):
    write += '\n'
    a = []
    for j in range(width):
      temp = array[i][j] * scale
      for k in temp:
        write += str(k) + ' '
        temp_w += str(k) + ' '
        a.append(k)

    for s in range(scale):
      write += '\n'
      write += temp_w
      arr.append(a)
    temp_w = ""

  return arr