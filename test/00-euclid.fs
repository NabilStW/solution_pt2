BEGINPROG Euclid
  a := (5 + 3) * (2 + 0)
  PRINT(a)
  b := -3 * -8
  PRINT(b) 
  WHILE (b > 0) DO
    c := b
    WHILE (a > b) DO
      a := a-b 
    ENDWHILE
    b := a
    a := c
  ENDWHILE
  PRINT(a)
ENDPROG
