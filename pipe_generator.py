import random

def pip_gen():

  f = open("pipe.txt", "a")
  write = ""

  for i in range(100):
    write += ('pipe_ran(' + str(i) + ') <= ' + str(random.randint(100, 400)) + '; ')
    if i % 7 == 0:
      write += '\n'

  f.write(write)
  f.close()


