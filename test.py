import re
m = re.search(r'a*(b+|c?)','df.aacaaabbc')
print(m.group())
b = m.group()
print(b)
s = m.start()
print(s)
e = m.end()
print(e)

